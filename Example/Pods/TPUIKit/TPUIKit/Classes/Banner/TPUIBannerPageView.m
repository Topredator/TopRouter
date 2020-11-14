//
//  TPUIBannerPageView.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIBannerPageView.h"

@interface TPUIBannerPageView ()
@property (nonatomic, readwrite, copy) NSString *reuseIdentifier;
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *tapGesture;
@end

@implementation TPUIBannerPageView
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.reuseIdentifier = NSStringFromClass([self class]);
    }
    return self;
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.reuseIdentifier = reuseIdentifier;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}
- (void)prepareForReuse {
    // 子类需要重写
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        _tapGesture.enabled = NO;
    }
    return _tapGesture;
}
@end
