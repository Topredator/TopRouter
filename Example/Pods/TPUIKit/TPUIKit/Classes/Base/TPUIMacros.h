//
//  TPUIMacros.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#ifndef TPUIMacros_h
#define TPUIMacros_h

#pragma mark ------------------------  System  ---------------------------
/// 屏幕宽
#define TPUIScreenWidth [[UIScreen mainScreen] bounds].size.width
/// 屏幕高
#define TPUIScreenHeight [[UIScreen mainScreen] bounds].size.height
/// 导航栏的高度
#define TPUINavigationBarHeight  44
/// 状态栏高度
#define TPUIIsIPhoneX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) || \
CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)) || \
CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) || \
CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)))
// 适配刘海屏状态栏高度
#define TPUIStatusBarHeight (TPUIIsIPhoneX ? 44.f : 20.f)
/// 头部的高 (状态栏 + 导航栏)
#define TPUITopBarHeight  (TPUIStatusBarHeight + TPUINavigationBarHeight)
/// tabbar 的高
#define TPUITabbarHeight 49
/// 底部bar的高 (tabbar的高 + 安全区的高)
#define TPUIBottomBarHeight  (TPUIStatusBarHeight > 20 ? 83 : 49)
/// 底部安全区的高度
#define TPUIBottomSafeAreaHeight  (TPUIStatusBarHeight > 20 ? 34 : 0)

#pragma mark ------------------------  UIColor  ---------------------------
#define TPUIRGB(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define TPUIRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define TPUIT(t) [UIColor colorWithRed:(t)/255.0f green:(t)/255.0f blue:(t)/255.0f alpha:1]
#define TPUITA(t, a) [UIColor colorWithRed:(t)/255.0f green:(t)/255.0f blue:(t)/255.0f alpha:(a)]


#define TPUIHEXColor(v) TPUIRGB((v & 0xFF0000) >> 16, (v & 0xFF00) >> 8, (v & 0xFF))
///hex alpha
#define TPUIHEXColorAlpha(v,a) TPUIRGBA((v & 0xFF0000) >> 16, (v & 0xFF00) >> 8, (v & 0xFF),a)
/// 随机色
#define TPUIRandomColor TPUIRGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#pragma mark ------------------------  宏方法  ---------------------------
#define  TPUIAdjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argumet = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argumet atIndex:2];\
[invocation invoke];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* TPUIMacros_h */
