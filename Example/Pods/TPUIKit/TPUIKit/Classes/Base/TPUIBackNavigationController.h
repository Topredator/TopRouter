//
//  TPUIBackNavigationController.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIBaseNavigationController.h"

/// 带返回按钮的导航控制器
@interface TPUIBackNavigationController : TPUIBaseNavigationController

@end

@interface UIViewController (TPUIBackNavigationController)
/// 返回响应
- (void)backAction:(id)sender;
@end

@interface UINavigationBar (XTBackNavigationController)
@end


