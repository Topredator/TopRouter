//
//  TPUINavigator.m
//  TPUIKit
//
//  Created by Topredator on 2019/2/21.
//

#import "TPUINavigator.h"

@implementation TPUINavigator

+ (UIViewController *)currentViewController {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self currentViewControllerFrom:rootVC];
}

+ (UINavigationController *)currentNavigationController
{
    UIViewController *currentViewController = self.currentViewController;
    return currentViewController.navigationController;
}
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //  不存在直接返回
    if (!viewController) return;
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return;
    } else {
        UINavigationController *navigationController = [TPUINavigator currentNavigationController];
        //  如果不存在导航控制器 直接返回
        if (!navigationController) return;
        [navigationController pushViewController:viewController animated:animated];
    }
}
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    return [self presentViewController:viewController animated:animated completion:nil];
}
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    //  不存在直接返回
    if (!viewController) return;
    UIViewController *currentViewController = [TPUINavigator currentViewController];
    if (!currentViewController) return;
    [currentViewController presentViewController:viewController animated:animated completion:completion];
}
+ (void)popViewControllerWithTimes:(NSUInteger)times animated:(BOOL)animated
{
    UIViewController *currentViewController = [TPUINavigator currentViewController];
    UINavigationController *currentNavigationController = currentViewController.navigationController;
    //  两者缺一不可
    if (!currentViewController || !currentNavigationController) return;
    NSUInteger count = currentNavigationController.viewControllers.count;
    if (count > times) {
        [currentNavigationController popToViewController:[currentNavigationController.viewControllers objectAtIndex:count - 1 - times] animated:animated];
    }
}
+ (void)popToRootViewControllerAnimated:(BOOL)animated
{
    UINavigationController *currentNavigationController = [TPUINavigator currentNavigationController];
    //  不存在导航控制器 直接返回
    if (!currentNavigationController) return;
    NSUInteger count = currentNavigationController.viewControllers.count;
    [self popViewControllerWithTimes:count - 1 animated:animated];
}

+ (void)dismissViewControllerTimes:(NSUInteger)times animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *currentViewController = [TPUINavigator currentViewController];
    //  两者缺一不可
    if (!currentViewController || !currentViewController.presentingViewController) return;
    while (times > 0) {
        currentViewController = currentViewController.presentingViewController;
        if (!currentViewController.presentingViewController) break;
        times -= 1;
    }
    [currentViewController dismissViewControllerAnimated:animated completion:completion];
}
+ (void)dismissToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *currentViewController = [TPUINavigator currentViewController];
    //  两者缺一不可
    if (!currentViewController || !currentViewController.presentingViewController) return;
    while (currentViewController.presentingViewController) {
        currentViewController = currentViewController.presentingViewController;
    }
    [currentViewController dismissViewControllerAnimated:animated completion:completion];
}

#pragma mark ==================  private method  ==================
// 通过递归拿到当前控制器
+ (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } // 如果传入的控制器是导航控制器,则返回最后一个
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } // 如果传入的控制器是tabBar控制器,则返回选中的那个
    else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    else {
        return viewController;
    }
}
@end
