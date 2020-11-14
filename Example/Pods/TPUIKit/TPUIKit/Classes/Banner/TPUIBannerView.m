//
//  TPUIBannerView.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIBannerView.h"
#import <objc/runtime.h>

static char kTPUIBannerPageViewPageIndexKey;

@interface TPUIBannerView ()<UIScrollViewDelegate>
@property (nonatomic, readwrite, strong) UIScrollView *scrollView;
@property (nonatomic, readwrite, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableDictionary *pages;
@property (nonatomic, strong) NSSet *pageIndexes;
@property (nonatomic, strong) NSMutableDictionary *reusablePages;
@property (nonatomic, assign) NSInteger innerCurrentPageIndex;
/// 当前的page滑动的比例
@property (nonatomic, assign) double currentPageRate;
/// 轮播的定时器
@property (nonatomic, strong) NSTimer *timer;
/// 定时器 是否有效
@property (nonatomic, assign) BOOL isTimerValid;
@end

@implementation TPUIBannerView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    self.clipsToBounds = YES;
    self.scrollDirection = TPUIBannerDirectionHorizontal;
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self.pageControl setFrame:CGRectMake(0, self.frame.size.height - 15, self.frame.size.width, 15)];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}
/// 处理页面警告
- (void)handleMemoryWarning {
    [self reusePageViewsIfNeededWithPageRate:self.currentPageRate];
    [self.reusablePages removeAllObjects];
}
- (void)pageControlChanged:(UIPageControl *)pageControl {
    [self setCurrentPageIndex:pageControl.currentPage animate:YES];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    NSInteger pageIndex = [self currentPageIndex];
    if ([self setScrollViewContentSizeIfNeed]) {
        [self setCurrentPageIndex:pageIndex animate:NO];
    }
}
- (void)didMoveToWindow {
    if (!self.window) {
        self.isTimerValid = [self.timer isValid];
        [self stopTimer];
    } else if (self.isTimerValid) {
        [self startTimerWithTimeInterval:self.timeInterval];
    }
}
#pragma mark ==================  private method  ==================
/// 是否需要设置contentSize
- (BOOL)setScrollViewContentSizeIfNeed {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    NSInteger count = [self numberOfPages];
    CGSize contentSize = CGSizeMake(width, height);
    if (count > 1) {
        count = self.isCarousel ? count + 2 : count;
        contentSize = (self.scrollDirection == TPUIBannerDirectionHorizontal) ? CGSizeMake(width * count, height) : CGSizeMake(width, height * count);
    }
    if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
        self.scrollView.frame = CGRectMake(0, 0, width, height);
        self.scrollView.contentSize = contentSize;
        return YES;
    }
    return NO;
}
/// 获取传入下标对应的真正下标
- (NSInteger)normalPageIndex:(NSInteger)pageIndex {
    /// 总数
    NSInteger count = [self numberOfPages];
    if (count <= 1) return 0;
    if (self.isCarousel) { // 是否无限循环
        if (pageIndex < 1) {
            pageIndex = count - 1;
        } else if (pageIndex > count) {
            pageIndex = 0;
        } else {
            pageIndex = pageIndex - 1;
        }
    } else if (pageIndex < 0) {
        pageIndex = count - 1;
    } else if (pageIndex >= count) {
        pageIndex = 0;
    }
    return pageIndex;
}
- (NSInteger)timerPageIndex:(NSInteger)pageIndex {
    NSInteger count = [self numberOfPages];
    if (count <= 1) return 0;
    count = self.isCarousel ? count + 2 : count;
    if (pageIndex < 0) {
        pageIndex = count - 1;
    } else if (pageIndex >= count) {
        pageIndex = 0;
    }
    return pageIndex;
}
/// pageIndex 是否有效
- (BOOL)isVaildPageIndex:(NSInteger)pageIndex {
    NSInteger count = [self numberOfPages];
    if (self.isCarousel) {
        if (count > 1) {
            return (pageIndex >= 0 && pageIndex < count + 2);
        } else {
            return (pageIndex == 0);
        }
    }
    return (pageIndex >= 0 &&pageIndex < count);
}
- (void)setCurrentPageIndex:(NSInteger)index animate:(BOOL)animate {
    if (self.isCarousel) {
        index = [self numberOfPages] > 1 ? index + 1 : 0;
    }
    [self setCurrentPageRate:index animate:animate scroll:YES];
}
- (void)setCurrentPageRate:(double)pageRate animate:(BOOL)animate scroll:(BOOL)scroll {
    NSInteger currentIndex = round(pageRate);
    // 如果当前分页不可用(即index无效,超出数组范围)，直接返回
    if (![self isVaildPageIndex:currentIndex]) return;
    
    // 滚动到指定分页
    if (scroll) {
        if (self.scrollDirection == TPUIBannerDirectionHorizontal) { // 竖屏或者竖直
            CGFloat offset = currentIndex * self.scrollView.frame.size.width;
            if (offset != self.scrollView.contentOffset.x) {
                [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:animate];
                return;
            }
        } else {
            CGFloat offset = currentIndex * self.scrollView.frame.size.height;
            if (offset != self.scrollView.contentOffset.y) {
                [self.scrollView setContentOffset:CGPointMake(0, offset) animated:animate];
                return;
            }
        }
    }
    self.pageControl.currentPage = [self currentPageIndex];
    // 如果当前滑动的比例，需要加载视图
    if ([self shouldLoadPagesAtPageRate:pageRate]) {
        _currentPageRate = pageRate;
        self.innerCurrentPageIndex = currentIndex;
        self.pageIndexes = [self usedPageIndexesWithPageRate:pageRate];
        // 重用分页
        [self reusePageViewsIfNeededWithPageRate:pageRate];
        // 加载分页
        [self loadPageViewsIfNeededWithPageRate:pageRate];
    }
}
// 当前滑动的比例 是否是需要加载视图
- (BOOL)shouldLoadPagesAtPageRate:(double)pageRate {
    if (ceil(_currentPageRate) != ceil(pageRate) || floor(_currentPageRate) != floor(pageRate)) {
        return YES;
    }
    NSInteger pageIndex = round(pageRate);
    NSInteger normalIndex = [self normalPageIndex:pageIndex];
    TPUIBannerPageView *pageView = [self.pages objectForKey:@(normalIndex)];
    if (!pageView) return YES;
    // 如果pageView的frame 与应当出现的frame不一致，则需要加载
    return !CGRectEqualToRect(pageView.frame, [self frameForPageViewAtIndex:pageIndex]);
}
- (CGRect)frameForPageViewAtIndex:(NSInteger)pageIndex {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    return (self.scrollDirection == TPUIBannerDirectionHorizontal) ? CGRectMake(width * pageIndex, 0, width, height) : CGRectMake(0, height * pageIndex, width, height);
}
- (NSSet *)usedPageIndexesWithPageRate:(double)pageRate {
    NSMutableSet *set = [NSMutableSet set];
    NSInteger leftIndex = floor(pageRate);
    NSInteger rightIndex = ceil(pageRate);
    if (self.preparedPageCount == 0) {
        if ([self isVaildPageIndex:leftIndex]) {
            [set addObject:@(leftIndex)];
        }
        if ([self isVaildPageIndex:rightIndex]) {
            [set addObject:@(rightIndex)];
        }
    } else {
        NSInteger currentIndex = round(pageRate);
        NSInteger preparedCount = self.preparedPageCount;
        for (NSInteger i = currentIndex - preparedCount; i <= currentIndex + preparedCount; i++) {
            if ([self isVaildPageIndex:i]) {
                [set addObject:@(i)];
            }
        }
    }
    return set;
}
- (void)reusePageViewsIfNeededWithPageRate:(double)pageRate {
    for (NSNumber *key in self.pages.allKeys.copy) {
        if (![self.pageIndexes containsObject:key]) {
            [self reusePageViewAtIndex:key.integerValue];
        }
    }
}
- (void)loadPageViewsIfNeededWithPageRate:(double)pageRate {
    for (NSNumber *key in self.pageIndexes.allObjects) {
        [self loadPageViewAtIndex:key.integerValue];
    }
}
// 加载分页
- (void)loadPageViewAtIndex:(NSInteger)pageIndex {
    if (![self isVaildPageIndex:pageIndex]) return;
    NSInteger normalIndex = [self normalPageIndex:pageIndex];
    NSNumber *key = @(normalIndex);
    TPUIBannerPageView *pageView = [self.pages objectForKey:key];
    if (!pageView) {
        pageView = [self.delegate bannerView:self viewForPageIndex:normalIndex];
        if (pageView) {
            [self.pages setObject:pageView forKey:key];
            [self.scrollView addSubview:pageView];
            [self handleTagGestureForPageView:pageView atPageIndex:normalIndex];
        }
    }
    pageView.frame = [self frameForPageViewAtIndex:pageIndex];
}
- (void)handleTagGestureForPageView:(TPUIBannerPageView *)pageView atPageIndex:(NSInteger)pageIndex {
    if ([self.delegate respondsToSelector:@selector(bannerView:canPageViewSelectedAtPageIndex:)]) {
        pageView.tapGesture.enabled = [self.delegate bannerView:self canPageViewSelectedAtPageIndex:pageIndex];
    } else {
        pageView.tapGesture.enabled = NO;
    }
    [pageView.tapGesture removeTarget:nil action:nil];
    objc_setAssociatedObject(pageView.tapGesture, &kTPUIBannerPageViewPageIndexKey, @(pageIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [pageView.tapGesture addTarget:self action:@selector(actionTap:)];
}
- (void)actionTap:(UITapGestureRecognizer *)tap {
    NSNumber *numPageIndex = objc_getAssociatedObject(tap, &kTPUIBannerPageViewPageIndexKey);
    if (numPageIndex && [self.delegate respondsToSelector:@selector(bannerView:didSelectedAtPageIndex:)]) {
        [self.delegate bannerView:self didSelectedAtPageIndex:numPageIndex.integerValue];
    }
}
/// 定时器事件
- (void)timerDidTriggered:(NSTimer *)timer {
    NSInteger pageIndex = [self timerPageIndex:_innerCurrentPageIndex + 1];
    [self setCurrentPageRate:pageIndex animate:YES scroll:YES];
}
- (void)reusePageViewAtIndex:(NSInteger)pageIndex {
    NSNumber *key = @(pageIndex);
    TPUIBannerPageView *pageView = [self.pages objectForKey:key];
    if (pageView) {
        [pageView prepareForReuse];
        [pageView removeFromSuperview];
        [self.pages removeObjectForKey:key];
        NSMutableSet *set = [self.reusablePages objectForKey:pageView.reuseIdentifier];
        if (!set) {
            set = [NSMutableSet setWithObject:pageView];
            [self.reusablePages setObject:set forKey:pageView.reuseIdentifier];
        } else {
            [set addObject:pageView];
        }
        if ([self.delegate respondsToSelector:@selector(bannerView:didPreparedForReuseAtPageIndex:)]) {
            [self.delegate bannerView:self didPreparedForReuseAtPageIndex:pageIndex];
        }
    }
}
- (void)cleanUp {
    for (NSNumber *key in [self.pages.allKeys copy]) {
        [self reusePageViewAtIndex:key.integerValue];
    }
    [self.reusablePages removeAllObjects];
}
#pragma mark ==================  public method  ==================
- (NSInteger)currentPageIndex {
    return [self normalPageIndex:_innerCurrentPageIndex];
}
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if (timeInterval == 0) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    if (_timer.timeInterval != timeInterval) {
        [_timer invalidate];
    }
    if (![_timer isValid]) {
        _timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(timerDidTriggered:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}
- (void)reloadData {
    [self reloadDataWithCurrentPageIndex:0];
}
- (void)reloadDataWithCurrentPageIndex:(NSInteger)index {
    self.pageControl.numberOfPages = [self numberOfPages];
    _innerCurrentPageIndex = NSNotFound;
    _currentPageRate = NSNotFound;
    // 清理
    [self cleanUp];
    // 判断线程 如果在主线程上直接执行，否则放入主队列当中
    if ([NSThread.currentThread isMainThread]) {
        [self setScrollViewContentSizeIfNeed];
        [self setCurrentPageIndex:index animate:NO];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setScrollViewContentSizeIfNeed];
            [self setCurrentPageIndex:index animate:NO];
        });
    }
}
- (TPUIBannerPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
    if (!identifier) return nil;
    NSMutableSet *pageSet = [self.reusablePages objectForKey:identifier];
    if (!pageSet || !pageSet.count) return nil;
    TPUIBannerPageView *pageView = [pageSet anyObject];
    [pageSet removeObject:pageView];
    return pageView;
}
#pragma mark ==================  UIScrollViewDelegate   ==================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    NSInteger count = [self numberOfPages];
    
    if (self.scrollDirection == TPUIBannerDirectionHorizontal) { // 水平
        CGFloat offset = scrollView.contentOffset.x;
        if (count <= 1 || width == 0) return;
        double pageRate = offset / width;
        NSInteger currentIndex = round(pageRate);
        if (self.isCarousel) {
            if (currentIndex < 1) {
                offset = width * count + offset;
                scrollView.contentOffset = CGPointMake(offset, 0);
                return;
            } else if (currentIndex > count) {
                offset = offset - width * count;
                scrollView.contentOffset = CGPointMake(offset, 0);
                return;
            }
        }
        [self setCurrentPageRate:pageRate animate:NO scroll:NO];
    } else { // 竖直方向
        CGFloat offset = scrollView.contentOffset.y;
        if (count <= 1 || height == 0) return;
        double pageRate = offset / height;
        NSInteger currentIndex = round(pageRate);
        if (self.isCarousel) {
            if (currentIndex < 1) {
                offset = height * count + offset;
                scrollView.contentOffset = CGPointMake(0, offset);
                return;
            } else if (currentIndex > count) {
                offset = offset - height * count;
                scrollView.contentOffset = CGPointMake(0, offset);
                return;
            }
        }
        [self setCurrentPageRate:pageRate animate:NO scroll:NO];
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerView:didShowPageViewAtIndex:)]) {
        [self.delegate bannerView:self didShowPageViewAtIndex:[self currentPageIndex]];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isTimerValid = [self.timer isValid];
    [self stopTimer];
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.isTimerValid) {
        [self startTimerWithTimeInterval:self.timeInterval];
    }
    if ([self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    if (!decelerate && [self.delegate respondsToSelector:@selector(bannerView:didShowPageViewAtIndex:)]) {
        [self.delegate bannerView:self didShowPageViewAtIndex:[self currentPageIndex]];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
    if ([self.delegate respondsToSelector:@selector(bannerView:didShowPageViewAtIndex:)]) {
        [self.delegate bannerView:self didShowPageViewAtIndex:[self currentPageIndex]];
    }
}
#pragma mark ================== lazy method ==================
- (void)setInnerCurrentPageIndex:(NSInteger)innerCurrentPageIndex {
    if (_innerCurrentPageIndex == innerCurrentPageIndex) return;
    if ([self.delegate respondsToSelector:@selector(bannerView:currentPageIndexDidChanged:)]) {
        NSInteger originIndex = [self currentPageIndex];
        _innerCurrentPageIndex = innerCurrentPageIndex;
        NSInteger currentIndex = [self currentPageIndex];
        if (originIndex != currentIndex) {
            [self.delegate bannerView:self currentPageIndexDidChanged:currentIndex];
        }
    } else {
        _innerCurrentPageIndex = innerCurrentPageIndex;
    }
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.directionalLockEnabled = YES;
        _scrollView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    return _pageControl;
}
- (NSInteger)numberOfPages {
    return [self.delegate numberOfPagesForBannerView:self];
}
- (NSMutableDictionary *)pages {
    if (!_pages) {
        _pages = [NSMutableDictionary dictionary];
    }
    return _pages;
}
- (NSMutableDictionary *)reusablePages {
    if (!_reusablePages) {
        _reusablePages = [NSMutableDictionary dictionary];
    }
    return _reusablePages;
}
@end
