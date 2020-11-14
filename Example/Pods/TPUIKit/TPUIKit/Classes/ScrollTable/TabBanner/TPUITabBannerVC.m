//
//  TPUITabBannerVC.m
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUITabBannerVC.h"
#import "TPUIMacros.h"
#import "TPUIBaseAccets.h"
#import <Masonry/Masonry.h>
@interface TPUITabBannerVC ()
/// 能否滑动
@property (nonatomic, assign, getter=isCanScroll) BOOL canScroll;
@end

@implementation TPUITabBannerVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[self allowSlideNotifyKey] object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 默认底部scroll可以滑动
    self.canScroll = YES;
    [self setupSubviews];
    [self makeConstraints];
    [self addBgScrollObserver];
}
- (void)setupSubviews {
    [self.view addSubview:self.bgScroll];
    [self.bgScroll addSubview:self.contentView];
    [self.contentView addSubview:self.tabbar];
    [self.contentView addSubview:self.bannerView];
}
- (void)makeConstraints {
    [self.bgScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgScroll);
        make.width.equalTo(self.bgScroll);
    }];
}
- (void)addBgScrollObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:[self allowSlideNotifyKey] object:nil];
}
- (void)setViewControllers:(NSArray<UIViewController<TPUISubVCScrollProtocol> *> *)viewControllers {
    _viewControllers = viewControllers;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    NSMutableArray *itemList = @[].mutableCopy;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
        TPUITabItem *item = [[TPUITabItem alloc] init];
        item.title = vc.title;
        [itemList addObject:item];
    }
    self.tabbar.items = itemList.copy;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.tabbar.selectedItemIndex = self.initialTabIndex;
        /// 刷新滚动视图
        [self.bannerView reloadDataWithCurrentPageIndex:self.initialTabIndex];
    });
}
- (NSString *)allowSlideNotifyKey {
    return [NSString stringWithFormat:@"%@_TPUI.scrollKey", NSStringFromClass(self.class)];
}
- (CGFloat)topOffset {
    return 0;
}
#pragma mark ------------------------  TPUIBannerViewDelegate  ---------------------------
/// banner的页面个数
- (NSInteger)numberOfPagesForBannerView:(TPUIBannerView *)bannerView {
    return self.viewControllers.count;
}
/// banner的页面
- (TPUIBannerPageView *)bannerView:(TPUIBannerView *)banner viewForPageIndex:(NSInteger)pageIndex {
    UIViewController *pageVC = [self.viewControllers objectAtIndex:pageIndex];
    TPUIBannerPageView *pageView = [banner dequeueReusablePageWithIdentifier:@"page"];
    if (!pageView) {
        pageView = [[TPUIBannerPageView alloc] initWithReuseIdentifier:@"page"];
    }
    if (![pageVC.view.superview isEqual:pageView]) {
        [pageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [pageView addSubview:pageVC.view];
        [pageVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
        pageVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return pageView;
}
- (void)bannerView:(TPUIBannerView *)bannerView didShowPageViewAtIndex:(NSInteger)pageIndex {
    [self.tabbar setSelectedItemIndex:pageIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.bgScroll) return;
    CGFloat offsetY = [self topOffset];
    if (scrollView.contentOffset.y >= offsetY) {
        scrollView.contentOffset = CGPointMake(0, offsetY);
        if (self.isCanScroll) {
            self.canScroll = NO;
            [self configSubVCWithCanScroll:YES offsetY:scrollView.contentOffset.y];
        }
    } else if (scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        if (self.isCanScroll) {
            self.canScroll = NO;
            [self configSubVCWithCanScroll:YES offsetY:scrollView.contentOffset.y];
        }
    } else {
        self.canScroll = YES;
        [self configSubVCWithCanScroll:NO offsetY:scrollView.contentOffset.y];
    }
    self.bgScroll.showsVerticalScrollIndicator = self.isCanScroll ? YES : NO;
}
- (void)changeScrollStatus {
    self.canScroll = YES;
    [self configSubVCWithCanScroll:NO offsetY:self.bgScroll.contentOffset.y];
}
- (void)configSubVCWithCanScroll:(BOOL)canScroll offsetY:(CGFloat)offsetY {
    for (UIViewController <TPUISubVCScrollProtocol>*vc in self.viewControllers) {
        vc.canScroll = canScroll;
        vc.superOfferY = offsetY;
    }
}
#pragma mark ------------------------  TPUITabbarDelegate  ---------------------------
- (void)tabbar:(TPUITabbar *)tabbar didSelectedItemAtIndex:(NSInteger)index {
    [self.bannerView setCurrentPageIndex:index animate:YES];
}
#pragma mark ------------------------  lazy method ---------------------------
- (TPUIGrScrollView *)bgScroll {
    if (!_bgScroll) {
        _bgScroll = [[TPUIGrScrollView alloc] initWithFrame:CGRectZero];
        _bgScroll.delegate = self;
        _bgScroll.bounces = NO;
    }
    return _bgScroll;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}
- (TPUITabbar *)tabbar {
    if (!_tabbar) {
        _tabbar = [[TPUITabbar alloc] initWithFrame:CGRectMake(0, 0, TPUIScreenWidth, 40)];
        _tabbar.itemTitleColor = TPUIT(153);
        _tabbar.itemTitleSelectedColor = TPUIT(51);
        _tabbar.itemTitleFont = [TPUIBaseAccets PFRegularFont:16];
        _tabbar.itemTitleSelectedFont = [TPUIBaseAccets PFMediumFont:20];
        _tabbar.indicatorColor = UIColor.clearColor;
        _tabbar.leadAndTrailSpace = 6;
        [_tabbar setScrollEnabledAndItemFitTextWidthWithSpacing:30];
        _tabbar.indicatorRadius = 1.5;
        _tabbar.indicatorColor = TPUIRGB(39, 119, 248);
        [_tabbar setIndicatorPosition:TPUIIndicatorPositionMake(0, 15, 3) tapSwitchAnimated:YES];
        _tabbar.delegate = self;
    }
    return _tabbar;
}
- (TPUIBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [[TPUIBannerView alloc] initWithFrame:CGRectZero];
        _bannerView.delegate = self;
        _bannerView.pageControl.hidden = YES;
        _bannerView.backgroundColor = UIColor.whiteColor;
    }
    return _bannerView;
}
@end
