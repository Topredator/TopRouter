//
//  TPUIBaseNavigationController.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import <UIKit/UIKit.h>

@interface TPUINavigationItem : NSObject
/// view正在出现中
@property (nonatomic, assign, readonly) BOOL isViewAppearing;
/// view正在消失中
@property (nonatomic, assign, readonly) BOOL isViewDisappearing;
/// 隐藏 navigationbar
@property (nonatomic, assign) BOOL navigationBarHidden;
/// 禁用 右滑返回
@property (nonatomic, assign) BOOL disableInteractivePopGestureRecognizer;
/// 动画隐藏navigationbar
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated;
@end

@interface UIViewController (TPUINavigationItem)
@property (nonatomic, strong, readonly) TPUINavigationItem *tpUINavigationItem;
@end


/// 基类 导航控制器
@interface TPUIBaseNavigationController : UINavigationController <UINavigationControllerDelegate>

@end


