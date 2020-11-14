//
//  TPUIGraphicView.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIGraphicView.h"
#import <Masonry/Masonry.h>
@interface TPUIGraphicView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TPUIGraphicView

+ (instancetype)view {
    return [[self alloc] initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconTextSpace = 4;
        _edgeInsets = UIEdgeInsetsZero;
        [self setupSubviews];
        [self makeConstrains];
    }
    return self;
}
- (void)setupSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}
- (void)makeConstrains {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(self);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.edgeInsets.left);
        make.centerY.mas_equalTo(0);
        make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
        make.bottom.mas_lessThanOrEqualTo(-self.edgeInsets.bottom);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(self.iconTextSpace);
        make.centerY.mas_equalTo(0);
        make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
        make.bottom.mas_lessThanOrEqualTo(- self.edgeInsets.bottom);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_right).offset(self.edgeInsets.right);
        make.right.equalTo(self);
    }];
}
- (void)setIconTextSpace:(CGFloat)iconTextSpace {
    _iconTextSpace = iconTextSpace;
    [self updateConstraintsIfConfig];
}
- (void)setIconPositionType:(TPUIGraphicIconPositionType)iconPositionType {
    _iconPositionType = iconPositionType;
    [self updateConstraintsIfConfig];
}
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self updateConstraintsIfConfig];
}
- (void)configImage:(UIImage *)image text:(NSString *)text {
    self.imageView.image = image;
    self.titleLabel.text = text;
}
- (void)updateConstraintsIfConfig {
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        if (self.iconPositionType == TPUIGraphicIconPositionTypeLeft ||
            self.iconPositionType == TPUIGraphicIconPositionTypeRight) {
            make.height.equalTo(self);
        } else {
            make.width.equalTo(self);
        }
    }];
    switch (self.iconPositionType) {
        case TPUIGraphicIconPositionTypeLeft: { // 图片 在左边
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.edgeInsets.left);
                make.centerY.mas_equalTo(0);
                make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
                make.bottom.mas_lessThanOrEqualTo(-self.edgeInsets.bottom);
            }];
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.imageView.mas_right).offset(self.iconTextSpace);
                make.centerY.mas_equalTo(0);
                make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
                make.bottom.mas_lessThanOrEqualTo(- self.edgeInsets.bottom);
            }];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.titleLabel.mas_right).offset(self.edgeInsets.right);
                make.right.equalTo(self);
            }];
        }
            break;
        case TPUIGraphicIconPositionTypeRight: { // 图片 在右边
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(- self.edgeInsets.right);
                make.centerY.mas_equalTo(0);
                make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
                make.bottom.mas_lessThanOrEqualTo(-self.edgeInsets.bottom);
            }];
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.imageView.mas_left).offset(- self.iconTextSpace);
                make.centerY.mas_equalTo(0);
                make.top.mas_greaterThanOrEqualTo(self.edgeInsets.top);
                make.bottom.mas_lessThanOrEqualTo(- self.edgeInsets.bottom);
            }];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_left).offset(- self.edgeInsets.left);
                make.left.equalTo(self);
            }];
        }
            break;
        case TPUIGraphicIconPositionTypeTop: {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.edgeInsets.top);
                make.centerX.mas_equalTo(0);
                make.left.mas_greaterThanOrEqualTo(self.edgeInsets.left);
                make.right.mas_lessThanOrEqualTo(-self.edgeInsets.right);
            }];
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageView.mas_bottom).offset(self.iconTextSpace);
                make.centerX.mas_equalTo(0);
                make.left.mas_greaterThanOrEqualTo(self.edgeInsets.left);
                make.right.mas_lessThanOrEqualTo(- self.edgeInsets.right);
            }];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.titleLabel.mas_bottom).offset(self.edgeInsets.bottom);
                make.bottom.equalTo(self);
            }];
        }
            break;
        default: {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.left.mas_greaterThanOrEqualTo(self.edgeInsets.left);
                make.right.mas_lessThanOrEqualTo(- self.edgeInsets.right);
                make.top.mas_equalTo(self.edgeInsets.top);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.left.mas_greaterThanOrEqualTo(self.edgeInsets.left);
                make.right.mas_lessThanOrEqualTo(-self.edgeInsets.right);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(self.iconTextSpace);
            }];
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.imageView.mas_bottom).offset(self.edgeInsets.bottom);
                make.bottom.equalTo(self);
            }];
        }
            break;
    }
}
#pragma mark ------------------------  lazy method ---------------------------
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _titleLabel;
}
@end
