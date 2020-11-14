//
//  TPUIScrollTableVC.h
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUIBaseViewController.h"
#import "TPUIScrollTopBar.h"
#import "TPUIBannerView.h"
NS_ASSUME_NONNULL_BEGIN


/// 列表嵌套视图
@interface TPUIScrollTableVC : TPUIBaseViewController <TPUIBannerViewDelegate, TPUITabbarDelegate>
/// 顶部选项栏
@property (nonatomic, strong) TPUIScrollTopBar *topTabBar;
/// 分页滚动容器
@property (nonatomic, strong) TPUIBannerView *banner;
/// 所有分页视图控制器
@property (nonatomic, copy) NSArray *viewControllers;
/// 初始选中的索引 (默认为0)
@property (nonatomic, assign) NSInteger initialTabIndex;
@end

NS_ASSUME_NONNULL_END
