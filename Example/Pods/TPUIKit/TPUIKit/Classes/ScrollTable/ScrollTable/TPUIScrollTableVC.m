//
//  TPUIScrollTableVC.m
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUIScrollTableVC.h"
#import "TPUIMacros.h"
#import <Masonry/Masonry.h>
@interface TPUIScrollTableVC ()
/// 管控 点击tabbarItem时，动画执行scroll，指示器动画错乱
@property (nonatomic, assign) BOOL isClickItem;
@end

@implementation TPUIScrollTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
}
- (void)setupSubviews {
    /// 有导航栏且半透明
    BOOL isFlag = (self.navigationController && self.navigationController.navigationBar.translucent);
    [self.view addSubview:self.banner];
    [self.view addSubview:self.topTabBar];
    if (isFlag) {
        self.topTabBar.frame = CGRectMake(0, TPUITopBarHeight, TPUIScreenWidth, kTPUIScrollTopBarHeight);
    }
    [self.banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(isFlag ? kTPUIScrollTopBarHeight + TPUITopBarHeight : kTPUIScrollTopBarHeight, 0, 0, 0));
    }];
}
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    NSMutableArray *itemList = @[].mutableCopy;
    for (UIViewController *vc in viewControllers) {
        [self addChildViewController:vc];
        TPUITabItem *item = [[TPUITabItem alloc] init];
        item.title = vc.title;
        [itemList addObject:item];
    }
    self.topTabBar.items = itemList.copy;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.topTabBar.selectedItemIndex = self.initialTabIndex;
        /// 刷新滚动视图
        [self.banner reloadDataWithCurrentPageIndex:self.initialTabIndex];
    });
}
#pragma mark ------------------------  TPUIBannerViewDelegate  ---------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isClickItem) return;
    CGFloat x = scrollView.contentOffset.x;
    NSInteger maxIndex = (NSInteger)(self.viewControllers.count - 1);
    if (x >= 0 && x <= TPUIScreenWidth * maxIndex) {
        [self.topTabBar updateSubViewsWhenParentScrollViewScroll:scrollView];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isClickItem = NO;
}
- (NSInteger)numberOfPagesForBannerView:(TPUIBannerView *)bannerView {
    return self.viewControllers.count;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.topTabBar.selectedItemIndex = page;
    self.isClickItem = NO;
}
- (TPUIBannerPageView *)bannerView:(TPUIBannerView *)banner viewForPageIndex:(NSInteger)pageIndex {
    UIViewController *pageVC = [self.viewControllers objectAtIndex:pageIndex];
    TPUIBannerPageView *pageView = [banner dequeueReusablePageWithIdentifier:@"page"];
    if (!pageView) {
        pageView = [[TPUIBannerPageView alloc] initWithReuseIdentifier:NSStringFromClass([pageVC class])];
    }
    if (![pageVC.view.superview isEqual:pageView]) {
        [pageView addSubview:pageVC.view];
        pageVC.view.frame = CGRectMake(0, 0, pageView.frame.size.width, pageView.frame.size.height);
        pageVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return pageView;
}
#pragma mark ------------------------  TPUITabbarDelegate  ---------------------------
- (void)tabbar:(TPUITabbar *)tabbar didSelectedItemAtIndex:(NSInteger)index {
    self.isClickItem = YES;
    [self.banner setCurrentPageIndex:index animate:YES];
}
#pragma mark ------------------------  lazy method ---------------------------
- (TPUIBannerView *)banner {
    if (!_banner) {
        _banner = [[TPUIBannerView alloc] initWithFrame:CGRectZero];
        _banner.delegate = self;
        _banner.pageControl.hidden = YES;
        TPUIAdjustsScrollViewInsets_NO(_banner.scrollView, self);
    }
    return _banner;
}
- (TPUIScrollTopBar *)topTabBar {
    if (!_topTabBar) {
        _topTabBar = [TPUIScrollTopBar tabbar];
        _topTabBar.delegate = self;
    }
    return _topTabBar;
}
@end
