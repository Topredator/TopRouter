//
//  TPUIGradientLayer.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, TPUIGradientDirection) {
    TPUIGradientDirectionTopToBottom, // 从上到下
    TPUIGradientDirectionBottomToTop, // 从下到上
    TPUIGradientDirectionLeftToRight, // 从左到右
    TPUIGradientDirectionRightToLeft, // 从右到左
};

/// 自定义 梯度layer
@interface TPUIGradientLayer : CAGradientLayer
+ (instancetype)gradientBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor direction:(TPUIGradientDirection)direction;
@end

/**
 内联函数 创建GradientLayer
 */
NS_INLINE TPUIGradientLayer *TPCreateGradientLayer(UIColor *beiginColor, UIColor *endColor, TPUIGradientDirection direction) {
    return [TPUIGradientLayer gradientBeginColor:beiginColor endColor:endColor direction:direction];
}
