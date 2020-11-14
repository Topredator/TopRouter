//
//  TPUIGradientButton.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <UIKit/UIKit.h>
#import "TPUIGradientLayer.h"

NS_ASSUME_NONNULL_BEGIN

/// 渐变 背景色 button
@interface TPUIGradientButton : UIButton
- (void)tpAddGradient:(TPUIGradientLayer *)layer;
@end

NS_ASSUME_NONNULL_END
