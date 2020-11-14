//
//  TPUIGradientLayer.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIGradientLayer.h"

@implementation TPUIGradientLayer
+ (instancetype)gradientBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor direction:(TPUIGradientDirection)direction {
    return [[self alloc] initWithBeginColor:beginColor endColor:endColor direction:direction];
}
- (instancetype)initWithBeginColor:(UIColor *)beginColor endColor:(UIColor *)endColor direction:(TPUIGradientDirection)direction {
    self = [super init];
    if (self) {
        self.colors = @[(__bridge id)beginColor.CGColor, (__bridge id)endColor.CGColor];
        switch (direction) {
            case TPUIGradientDirectionTopToBottom: {
                self.startPoint = CGPointMake(0.5, 0);
                self.endPoint = CGPointMake(0.5, 1);
            }
                break;
            case TPUIGradientDirectionBottomToTop: {
                self.startPoint = CGPointMake(0.5, 1);
                self.endPoint = CGPointMake(0.5, 0);
            }
                break;
            case TPUIGradientDirectionLeftToRight: {
                self.startPoint = CGPointMake(0, 0.5);
                self.endPoint = CGPointMake(1, 0.5);
            }
                break;
            case TPUIGradientDirectionRightToLeft: {
                self.startPoint = CGPointMake(1, 0.5);
                self.endPoint = CGPointMake(0, 0.5);
            }
                break;
        }
    }
    return self;
}
@end
