//
//  TPUIMarginLabel.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import "TPUIMarginLabel.h"

@implementation TPUIMarginLabel

+ (instancetype)marginLabel:(UIEdgeInsets)textInsets {
    TPUIMarginLabel *label = [[self alloc] initWithFrame:CGRectZero];
    label.textInsets = textInsets;
    return label;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.textInsets = UIEdgeInsetsZero;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textInsets = UIEdgeInsetsZero;
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.textInsets = UIEdgeInsetsZero;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.textInsets) limitedToNumberOfLines:numberOfLines];
    rect.origin.x -= self.textInsets.left;
    rect.origin.y -= self.textInsets.top;
    rect.size.width += self.textInsets.left + self.textInsets.right;
    rect.size.height += self.textInsets.top + self.textInsets.bottom;
    return rect;
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

@end
