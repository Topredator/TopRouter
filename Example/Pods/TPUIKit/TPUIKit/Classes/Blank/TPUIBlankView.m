//
//  TPBlankView.m
//  TPUIKit
//
//  Created by Topredator on 2019/3/1.
//

#import "TPUIBlankView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

static CGFloat kTPBlankViewHiddenAnimationDiration = 0.25;

static char kBlankViewKey;
@implementation TPUIBlankView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setupSubviews];
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setupSubviews];
    return self;
}
+ (instancetype)blankView {
    return [[self alloc] init];
}
+ (TPUIBlankView *)blankViewInView:(__kindof UIView *)view {
    return objc_getAssociatedObject(view, &kBlankViewKey);
}
+ (instancetype)showInView:(__kindof UIView *)view animated:(BOOL)animated {
    TPUIBlankView *blankView = [self blankView];
    [blankView showInView:view animated:animated];
    return blankView;
}
+ (instancetype)hideInView:(__kindof UIView *)view animated:(BOOL)animated {
    TPUIBlankView *blankView = [self blankViewInView:view];
    [blankView hideWithAnimated:animated];
    return blankView;
}
- (void)showInView:(__kindof UIView *)view animated:(BOOL)animated {
    TPUIBlankView *oldBlankView = [TPUIBlankView blankViewInView:view];
    if (!view || [oldBlankView isEqual:self]) return;
    if (oldBlankView) [oldBlankView hideWithAnimated:animated];
    objc_setAssociatedObject(view, &kBlankViewKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.alpha = 0;
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(0);
        make.right.mas_lessThanOrEqualTo(0);
        make.bottom.mas_lessThanOrEqualTo(0);
        if (self.topOffset == 0) {
            make.centerY.mas_equalTo(0);
        } else {
            make.top.mas_equalTo(self.topOffset);
        }
    }];
    if (!animated) {
        self.alpha = 1;
        return;
    }
    [UIView transitionWithView:self duration:kTPBlankViewHiddenAnimationDiration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.alpha = 1;
    } completion:nil];
}
- (void)hideWithAnimated:(BOOL)animated {
    if (self.superview) {
        objc_setAssociatedObject(self.superview, &kBlankViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (!animated) {
            self.alpha = 0;
            [self removeFromSuperview];
            return;
        }
        [UIView transitionWithView:self duration:kTPBlankViewHiddenAnimationDiration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}
- (void)setupSubviews {}
#pragma mark ==================  lazy method  ==================
- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;
    [_contentView removeFromSuperview];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}
- (void)setTopOffset:(CGFloat)topOffset {
    if (_topOffset != topOffset && self.superview) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.superview);
            make.left.greaterThanOrEqualTo(self.superview);
            make.right.lessThanOrEqualTo(self.superview);
            make.bottom.lessThanOrEqualTo(self.superview);
            if (topOffset == 0) {
                make.centerY.equalTo(self.superview);
            } else {
                make.top.equalTo(self.superview).offset(topOffset);
            }
        }];
    }
    _topOffset = topOffset;
}
- (void)setCustomEdgeInsets:(UIEdgeInsets)customEdgeInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_customEdgeInsets, customEdgeInsets) && self.superview) {
        CGFloat offsetX = (customEdgeInsets.left - customEdgeInsets.right) / 2.0;
        CGFloat offSetY = (customEdgeInsets.top - customEdgeInsets.bottom) / 2.0;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(offsetX);
            make.centerY.mas_equalTo(offSetY);
            make.edges.mas_equalTo(customEdgeInsets);
        }];
        [self.superview layoutIfNeeded];
    }
    _customEdgeInsets = customEdgeInsets;
}
@end
@implementation TPUIImageBlankView
@synthesize imageView = _imageView;
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.clipsToBounds = YES;
        [_imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (void)setupSubviews {
    self.contentView = self.imageView;
}
@end
@implementation TPUIActivityBlankView
@synthesize activitiyView = _activitiyView;
- (UIActivityIndicatorView *)activitiyView {
    if (!_activitiyView) {
        _activitiyView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activitiyView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_activitiyView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [_activitiyView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [_activitiyView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        _activitiyView.color = [UIColor grayColor];
    }
    return _activitiyView;
}
- (void)setupSubviews {
    self.contentView = self.activitiyView;
}
- (void)showInView:(__kindof UIView *)view animated:(BOOL)animated {
    [super showInView:view animated:animated];
    [self.activitiyView startAnimating];
}
- (void)hideWithAnimated:(BOOL)animated {
    [super hideWithAnimated:animated];
    [self.activitiyView stopAnimating];
}
@end

@interface TPUITextBlankView ()
@property (nonatomic, copy) void (^refreshBlock)(void);
@end

@implementation TPUITextBlankView
@synthesize textLabel = _textLabel;
@synthesize subTextLabel = _subTextLabel;
@synthesize refreshButton = _refreshButton;

- (void)setupSubviews {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [contentView addSubview:self.imageView];
    [contentView addSubview:self.textLabel];
    [contentView addSubview:self.subTextLabel];
    [contentView addSubview:self.refreshButton];
    self.contentView = contentView;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(10);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(10);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    [self.subTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
        make.left.mas_greaterThanOrEqualTo(10);
        make.right.mas_lessThanOrEqualTo(-10);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTextLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_greaterThanOrEqualTo(130);
        make.width.mas_lessThanOrEqualTo(220);
    }];
}
- (void)setRefreshTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self.refreshButton setTitle:title forState:UIControlStateNormal];
    self.refreshButton.hidden = !title;
    [self.refreshButton removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
    if (target && action) {
        [self.refreshButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)setRefreshTitle:(NSString *)title actionBlock:(void (^)(void))block {
    self.refreshBlock = block;
    [self setRefreshTitle:title target:self action:@selector(actionRefresh:)];
}
- (void)actionRefresh:(id)sender {
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
#pragma mark ==================  lazy method ==================
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 7;
        _textLabel.font = [UIFont systemFontOfSize:17.0];
        _textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    }
    return _textLabel;
}
- (UILabel *)subTextLabel {
    if (!_subTextLabel) {
        _subTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTextLabel.textAlignment = NSTextAlignmentCenter;
        _subTextLabel.numberOfLines = 7;
        _subTextLabel.font = [UIFont systemFontOfSize:15.0];
        _subTextLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    }
    return _subTextLabel;
}
- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _refreshButton.backgroundColor = [UIColor colorWithRed:13.0/255.0 green:217.0/255.0 blue:166.0/255.0 alpha:1];
        _refreshButton.layer.cornerRadius = 20;
        _refreshButton.clipsToBounds = YES;
        _refreshButton.titleLabel.textColor = [UIColor whiteColor];
        _refreshButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _refreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _refreshButton.hidden = YES;
    }
    return _refreshButton;
}
@end
