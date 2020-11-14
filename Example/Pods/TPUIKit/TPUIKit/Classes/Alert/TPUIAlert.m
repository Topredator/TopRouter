//
//  TPUIAlert.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIAlert.h"

@implementation TPUIAlert
+ (instancetype)alertShow:(void (^)(TPUIAlertMaker *))maker {
    return [self alertShow:maker completion:nil];
}

+ (instancetype)alertShow:(void (^)(TPUIAlertMaker *))maker completion:(void(^)(void))completion {
    TPUIAlert *alert = [TPUIAlert new];
    alert.alertMark = [TPUIAlertMaker new];
    maker(alert.alertMark);
    [alert buildAlertController:completion];
    return alert;
}

+ (instancetype)alertSheetShow:(void (^)(TPUIAlertMaker *))maker {
    return [self alertSheetShow:maker completion:nil];
}
+ (instancetype)alertSheetShow:(void (^)(TPUIAlertMaker *make))maker completion:(void (^)(void))completion {
    TPUIAlert *alert = [TPUIAlert new];
    TPUIAlertMaker *alertMarker = [TPUIAlertMaker new];
    alertMarker.alertStyle = UIAlertControllerStyleActionSheet;
    alert.alertMark = alertMarker;
    maker(alert.alertMark);
    [alert buildAlertController:completion];
    return alert;
}


- (void)buildAlertController:(void(^)(void))completion {
    if (!self.alertMark.options.count) return;
    /// 适配iPad
    if (self.alertMark.alertStyle == UIAlertControllerStyleActionSheet && UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.alertMark.alertStyle = UIAlertControllerStyleAlert;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.alertMark.alertTitle message:self.alertMark.alertMessage preferredStyle:self.alertMark.alertStyle];
    for (TPUIAlertOption *option in self.alertMark.options) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:option.title style:option.actionStyle handler:^(UIAlertAction * _Nonnull action) {
            // block
            if (option.block) {
                option.block();
            }
            // target action
            if (option.target && option.selector) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [option.target performSelector:option.selector];
#pragma clang diagnostic pop
            }
        }];
        if (option.textColor) { // 颜色设置
            [action setValue:option.textColor forKey:@"titleTextColor"];
        }
        [alertController addAction:action];
    }
    UIViewController *currentVC = [self currentViewControllerFrom:[UIApplication sharedApplication].delegate.window.rootViewController];
    [currentVC presentViewController:alertController animated:YES completion:completion];
}

- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
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
