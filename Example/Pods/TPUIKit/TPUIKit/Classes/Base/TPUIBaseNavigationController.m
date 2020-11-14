//
//  TPUIBaseNavigationController.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIBaseNavigationController.h"
#import "TPUIMethodSwizzling.h"
#import <objc/runtime.h>

@interface TPUINavigationItem ()
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, assign, readwrite) BOOL isViewAppearing;
@property (nonatomic, assign, readwrite) BOOL isViewDisappearing;
/// 更新 navigationbar的显隐
- (void)updateNavigationBarHiddenAnimated:(BOOL)animated;
@end

@implementation TPUINavigationItem
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [self setNavigationBarHidden:navigationBarHidden animated:NO];
}
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden animated:(BOOL)animated {
    _navigationBarHidden = navigationBarHidden;
    [self updateNavigationBarHiddenAnimated:animated];
}
- (void)updateNavigationBarHiddenAnimated:(BOOL)animated {
    if (self.navigationController && self.navigationController.navigationBarHidden != _navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:_navigationBarHidden animated:animated];
    }
}
@end


static char kTPUINavigationItemKey;
@implementation UIViewController (TPUINavigationItem)
@dynamic tpUINavigationItem;
- (TPUINavigationItem *)tpUINavigationItem {
    TPUINavigationItem *item = objc_getAssociatedObject(self, &kTPUINavigationItemKey);
    if (!item) {
        item = [TPUINavigationItem new];
        objc_setAssociatedObject(self, &kTPUINavigationItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return item;
}
+ (void)load {
    TPUIKitSwizzling(self, @selector(viewWillAppear:), @selector(tp_viewWillAppear:));
    TPUIKitSwizzling(self, @selector(viewDidAppear:), @selector(tp_viewDidAppear:));
    TPUIKitSwizzling(self, @selector(viewWillDisappear:), @selector(tp_viewWillDisappear:));
    TPUIKitSwizzling(self, @selector(viewDidDisappear:), @selector(tp_viewDidDisappear:));
}
- (void)tp_viewWillAppear:(BOOL)animated {
    self.tpUINavigationItem.isViewAppearing = YES;
    [self tp_viewWillAppear:animated];
}
- (void)tp_viewDidAppear:(BOOL)animated {
    if (self.tpUINavigationItem) {
        self.tpUINavigationItem.isViewAppearing = NO;
        // 正在消失
        if (self.tpUINavigationItem.isViewDisappearing) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tpUINavigationItem updateNavigationBarHiddenAnimated:NO];
            });
        }
    }
    [self tp_viewDidAppear:animated];
}
- (void)tp_viewWillDisappear:(BOOL)animated {
    self.tpUINavigationItem.isViewDisappearing = YES;
    [self tp_viewWillDisappear:animated];
}
- (void)tp_viewDidDisappear:(BOOL)animated {
    self.tpUINavigationItem.isViewDisappearing = NO;
    [self tp_viewDidDisappear:animated];
}
@end


@interface TPUIBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation TPUIBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
    [super setDelegate:self];
}
//支持旋转
- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}
//默认的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
#pragma mark ==================  UIGestureRecognizerDelegate   ==================
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
        UIViewController *topVC = [self topViewController];
        if (topVC.tpUINavigationItem.disableInteractivePopGestureRecognizer) {
            return NO;
        }
    }
    return YES;
}
#pragma mark ==================  UINavigationControllerDelegate   ==================
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    viewController.tpUINavigationItem.navigationController = self;
    [viewController.tpUINavigationItem updateNavigationBarHiddenAnimated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = !viewController.tpUINavigationItem.disableInteractivePopGestureRecognizer;
    }
}
@end
