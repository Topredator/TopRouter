//
//  TPUINavigator.h
//  TPUIKit
//
//  Created by Topredator on 2019/2/21.
//

#import <Foundation/Foundation.h>



@interface TPUINavigator : NSObject
/**
 获取当前界面控制器
 
 @return 当前控制器
 */
+ (UIViewController *)currentViewController;

/**
 获取当前导航控制器
 
 @return 当前导航控制器
 */
+ (UINavigationController *)currentNavigationController;
/**
 push 控制器
 
 @param viewController 目标控制器
 @param animated 动画
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 model 控制器
 
 @param viewController 目标控制器
 @param animated 动画
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**
 model 控制器
 
 @param viewController 目标控制器
 @param animated 动画
 @param completion 完成时的操作
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
/**
 pop 控制器
 
 @param times 层数
 @param animated 动画
 */
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated;

/**
 pop 到根试图控制器
 
 @param animated 动画
 */
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

/**
 dismiss 控制器
 
 @param times 层数
 @param animated 动画
 @param completion 完成时操作
 */
+ (void)dismissViewControllerTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 dismiss 根试图控制器
 
 @param animated 动画
 @param completion 完成时操作
 */
+ (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;
@end

