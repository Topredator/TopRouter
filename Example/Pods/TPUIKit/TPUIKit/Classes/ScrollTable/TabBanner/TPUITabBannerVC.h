//
//  TPUITabBannerVC.h
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUIBaseViewController.h"
#import "TPUIGrScrollView.h"
#import "TPUIBannerView.h"
#import "TPUITabbar.h"
#import "TPUISubVCScrollProtocol.h"

NS_ASSUME_NONNULL_BEGIN
/// 可上下滑动的 列表嵌套视图
@interface TPUITabBannerVC : TPUIBaseViewController <TPUIBannerViewDelegate, TPUITabbarDelegate>
/// 底部 scroll
@property (nonatomic, strong) TPUIGrScrollView *bgScroll;
/// 内容容器
@property (nonatomic, strong) UIView *contentView;

/// 顶部选项栏
@property (nonatomic, strong) TPUITabbar *tabbar;
/// 分页滚动容器
@property (nonatomic, strong) TPUIBannerView *bannerView;
/// 所有分页视图控制器
@property (nonatomic, copy) NSArray <UIViewController<TPUISubVCScrollProtocol> *>*viewControllers;
/// 初始选中的索引 (默认为0)
@property (nonatomic, assign) NSInteger initialTabIndex;


/// 向上偏移多少才能左右滑动
- (CGFloat)topOffset;
/// 允许滑动通知的key
- (NSString *)allowSlideNotifyKey;
/// 添加子视图 （需调用父类）
- (void)setupSubviews;
/// 为子视图添加约束 (需调用父类)
- (void)makeConstraints;

@end

NS_ASSUME_NONNULL_END
