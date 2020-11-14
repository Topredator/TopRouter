//
//  TPUITabItem.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import "TPUITabItem.h"

@interface TPUITabItem ()
@property (nonatomic, strong) UILabel *badgeLabel;

/// Image与title 竖直方向上的偏移量
@property (nonatomic, assign) CGFloat verticalOffset;
/// Image与title 间距
@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, assign) CGFloat numberBadgeMarginTop;
@property (nonatomic, assign) CGFloat numberBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat numberBadgeTitleHorizonalSpace;
@property (nonatomic, assign) CGFloat numberBadgeTitleVerticalSpace;

@property (nonatomic, assign) CGFloat dotBadgeMarginTop;
@property (nonatomic, assign) CGFloat dotBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat dotBadgeSideLength;
@end

@implementation TPUITabItem

#pragma mark ==================  init method  ==================
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    TPUITabItem *tabItem = [super buttonWithType:buttonType];
    [tabItem setup];
    return tabItem;
}
- (void)setup {
    [self addSubview:self.badgeLabel];
    /// 关闭高亮
    self.adjustsImageWhenHighlighted = NO;
    /// 默认数字模式  为0
    _badgeStyle = TPUITabItemBadgeStyleNumber;
    _badge = 0;
    _titleFont = [UIFont systemFontOfSize:18];
    _indicatorInsets = UIEdgeInsetsZero;
}
#pragma mark ==================  Public methods  ==================
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight titleHorizonalSpace:(CGFloat)titleHorizonalSpace titleVerticalSpace:(CGFloat)titleVerticalSpace {
    self.numberBadgeMarginTop = marginTop;
    self.numberBadgeCenterMarginRight = centerMarginRight;
    self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace;
    self.numberBadgeTitleVerticalSpace = titleVerticalSpace;
    [self updateBadge];
}
- (void)setDotBadgeMarginTop:(CGFloat)marginTop centerMarginRight:(CGFloat)centerMarginRight sideLength:(CGFloat)sideLength {
    self.dotBadgeMarginTop = marginTop;
    self.dotBadgeCenterMarginRight = centerMarginRight;
    self.dotBadgeSideLength = sideLength;
    [self updateBadge];
    
}
#pragma mark ==================  Private methods  ==================
/**
 *  覆盖父类的setHighlighted:方法，按下YPTabItem时，不高亮该item
 */
- (void)setHighlighted:(BOOL)highlighted {
    if (self.adjustsImageWhenHighlighted) {
        [super setHighlighted:highlighted];
    }
}
- (void)setContentHorizontalCenter:(BOOL)contentHorizontalCenter {
    _contentHorizontalCenter = contentHorizontalCenter;
    if (!_contentHorizontalCenter) {
        self.verticalOffset = 0;
        self.spacing = 0;
    }
    if (self.superview) {
        [self layoutSubviews];
    }
}
- (void)setContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                             spacing:(CGFloat)spacing {
    self.verticalOffset = verticalOffset;
    self.spacing = spacing;
    self.contentHorizontalCenter = YES;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self imageForState:UIControlStateNormal] && self.contentHorizontalCenter) {
        CGSize titleSize = self.titleLabel.frame.size;
        CGSize imageSize = self.imageView.frame.size;
        titleSize = CGSizeMake(ceilf(titleSize.width), ceilf(titleSize.height));
        CGFloat totalHeight = (imageSize.height + titleSize.height + self.spacing);
        self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height - self.verticalOffset), 0, 0, - titleSize.width);
        self.titleEdgeInsets = UIEdgeInsetsMake(self.verticalOffset, - imageSize.width, - (totalHeight - titleSize.height), 0);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsZero;
        self.titleEdgeInsets = UIEdgeInsetsZero;
    }
}
- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
    [self calculateTitleWidth];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor {
    _titleSelectedColor = titleSelectedColor;
    [self setTitleColor:titleSelectedColor forState:UIControlStateSelected];
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8) {
        self.titleLabel.font = titleFont;
    }
    [self calculateTitleWidth];
}
/**
 计算文字的宽度
 */
- (void)calculateTitleWidth {
    if (self.title.length == 0) {
        _titleWidth = 0;
        return;
    }
    CGSize size = [self.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName : self.titleFont}
                                           context:nil].size;
    _titleWidth = ceilf(size.width);
}
- (void)setImage:(UIImage *)image {
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
}
- (void)setSelectedImage:(UIImage *)selectedImage {
    _selectedImage = selectedImage;
    [self setImage:selectedImage forState:UIControlStateSelected];
}
#pragma mark ==================  badge methods  ==================
- (void)setBadge:(NSInteger)badge {
    _badge = badge;
    [self updateBadge];
}
- (void)setBadgeStyle:(TPUITabItemBadgeStyle)badgeStyle {
    _badgeStyle = badgeStyle;
    [self updateBadge];
}
/**
 更新badge
 */
- (void)updateBadge {
    if (self.badgeStyle == TPUITabItemBadgeStyleNumber) {
        if (self.badge <= 0) {
            self.badgeLabel.hidden = YES;
        } else {
            NSString *badgeStr = @(self.badge).stringValue;
            if (self.badge > 99) {
                badgeStr = @"99+";
            }
            
            // 计算badgeStr的size
            CGSize size = [badgeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : self.badgeLabel.font}
                                                 context:nil].size;
            // 计算badgeButton的宽度和高度
            CGFloat width = ceilf(size.width) + self.numberBadgeTitleHorizonalSpace;
            CGFloat height = ceilf(size.height) + self.numberBadgeTitleVerticalSpace;
            // 宽度取width和height的较大值，使badge为个位数时，badgeButton为圆形
            width = MAX(width, height);
            
            // 设置badgeButton的frame
            self.badgeLabel.frame = CGRectMake(self.bounds.size.width - width / 2 - self.numberBadgeCenterMarginRight,
                                               self.numberBadgeMarginTop,
                                               width,
                                               height);
            self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.size.height / 2;
            self.badgeLabel.text = badgeStr;
            self.badgeLabel.hidden = NO;
        }
    } else if (self.badgeStyle == TPUITabItemBadgeStyleDot) {
        self.badgeLabel.text = @"";
        self.badgeLabel.frame = CGRectMake(self.bounds.size.width - self.dotBadgeCenterMarginRight - self.dotBadgeSideLength,
                                           self.dotBadgeMarginTop,
                                           self.dotBadgeSideLength,
                                           self.dotBadgeSideLength);
        self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.size.height / 2;
        self.badgeLabel.hidden = NO;
    }
}
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    self.badgeLabel.backgroundColor = badgeBackgroundColor;
}
- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    self.badgeLabel.textColor = badgeTitleColor;
}
- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    _badgeTitleFont = badgeTitleFont;
    self.badgeLabel.font = badgeTitleFont;
}
- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets {
    _indicatorInsets = indicatorInsets;
    [self calculateIndicatorFrame];
}
- (void)calculateIndicatorFrame {
    CGRect frame = self.frameWithOutTransform;
    UIEdgeInsets insets = self.indicatorInsets;
    _indicatorFrame = CGRectMake(frame.origin.x + insets.left,
                                 frame.origin.y + insets.top,
                                 frame.size.width - insets.left - insets.right,
                                 frame.size.height - insets.top - insets.bottom);
}

#pragma mark ==================  lazy methods  ==================
- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [UILabel new];
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        _badgeTitleFont = [UIFont systemFontOfSize:13];
    }
    return _badgeLabel;
}
- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}
- (CGSize)size {
    return self.frame.size;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _frameWithOutTransform = frame;
    [self updateBadge];
    [self calculateIndicatorFrame];
}
@end
