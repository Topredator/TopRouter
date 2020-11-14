//
//  TPUIBackNavigationController.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIBackNavigationController.h"
#import "UIBarButtonItem+TPUIButtonItem.h"
@interface TPUIBackNavigationController ()

@end

@implementation TPUIBackNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem tp_backItemWithTarget:viewController action:@selector(backAction:)];
    }
    [super pushViewController:viewController animated:animated];
}
@end


@implementation UIViewController (TPUIBackNavigationController)
- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

@implementation UINavigationBar (XTBackNavigationController)
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        self.userInteractionEnabled = YES;
    } else {
        self.userInteractionEnabled = NO;
    }
    return [super hitTest:point withEvent:event];
}
@end
