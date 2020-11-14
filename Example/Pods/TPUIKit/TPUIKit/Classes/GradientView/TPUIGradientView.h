//
//  TPUIGradientView.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <UIKit/UIKit.h>
#import "TPUIGradientLayer.h"

NS_ASSUME_NONNULL_BEGIN

/// 渐变背景色 View
@interface TPUIGradientView : UIView
- (void)tpAddGradient:(TPUIGradientLayer *)layer;
@end

NS_ASSUME_NONNULL_END
