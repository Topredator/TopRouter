//
//  TPUIScrollTopBar.m
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUIScrollTopBar.h"
#import "TPUIMacros.h"
#import "TPUIBaseAccets.h"
const CGFloat kTPUIScrollTopBarHeight = 45;

@implementation TPUIScrollTopBar

+ (instancetype)tabbar {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, TPUIScreenWidth, kTPUIScrollTopBarHeight)];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.itemTitleColor = TPUIT(102);
    self.itemTitleSelectedColor = TPUIT(51);
    self.itemTitleFont = [TPUIBaseAccets PFMediumFont:15];
    self.itemTitleSelectedFont = [TPUIBaseAccets PFMediumFont:15];
    self.indicatorScrollFollowContent = YES;
    self.indicatorColor = TPUIRGB(39, 119, 248);
    [self setIndicatorWidthFixTextAndMarginTop:kTPUIScrollTopBarHeight - 2 marginBottom:0 tapSwitchAnimated:YES];
}
@end
