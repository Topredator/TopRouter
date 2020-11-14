//
//  UIView+TPBlankView.m
//  TPUIKit
//
//  Created by Topredator on 2019/3/1.
//

#import "UIView+TPBlankView.h"
#import "TPUIBlankView.h"
#import "TPUIBlankAccets.h"
#import <Masonry/Masonry.h>

#define force_inline __inline__ __attribute__((always_inline))

static force_inline TPUITextBlankView *TPCreateTextBlankView(__kindof UIView *view, UIImage *image, NSString *text, NSString *subText) {
    TPUITextBlankView *blankView = [TPUITextBlankView showInView:view animated:YES];
    blankView.imageView.image = image;
    blankView.textLabel.text = text;
    blankView.subTextLabel.text = subText;
    return blankView;
}

@implementation UIView (TPBlankView)
- (TPUIActivityBlankView *)tp_showActivityBlankView {
    return [TPUIActivityBlankView showInView:self animated:YES];
}
- (TPUIImageBlankView *)tp_showLoadingBlankView {
    NSMutableArray *images = @[].mutableCopy;
    for (NSInteger i = 0; i <= 49; i++) {
        UIImage *image = [TPUIBlankAccets imageName:[NSString stringWithFormat:@"loading1_000%02ld", i]];
        [images addObject:image];
    }
    return [self tp_showLoading:images text:nil size:CGSizeMake(180, 90)];
}
- (TPUIImageBlankView *)tp_showLoading:(NSArray <UIImage *>*)images text:(NSString *)text size:(CGSize)size {
    TPUITextBlankView *blankView = [TPUITextBlankView showInView:self animated:YES];
    blankView.imageView.animationImages = images;
    blankView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    blankView.imageView.animationDuration = 3.5f;
    blankView.imageView.animationRepeatCount = 0;
    [blankView.imageView startAnimating];
    blankView.subTextLabel.text = text;
    [blankView.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return blankView;
}
- (TPUIImageBlankView *)tp_showBlankViewWithImage:(UIImage *)image {
    return [self tp_showTextBlankViewWithImage:image text:nil];
}
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text {
    return [self tp_showTextBlankViewWithImage:image text:text subText:nil];
}
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText {
    return [self tp_showTextBlankViewWithImage:image text:text subText:subText refreshTitle:nil refreshTarget:nil action:nil];
}
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText refreshTitle:(NSString *)title refreshTarget:(id)target action:(SEL)action {
    TPUITextBlankView *blankView = TPCreateTextBlankView(self, image, text, subText);
    [blankView setRefreshTitle:title target:target action:action];
    return blankView;
}
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText refreshTitle:(NSString *)title refreshBlock:(void(^)(void))refreshBlock {
    TPUITextBlankView *blankView = TPCreateTextBlankView(self, image, text, subText);
    [blankView setRefreshTitle:title actionBlock:refreshBlock];
    return blankView;
}
- (void)tp_hideBlankView {
    [self tp_hideBlankViewAnimated:NO];
}
- (void)tp_hideBlankViewAnimated:(BOOL)animated {
    [TPUIBlankView hideInView:self animated:animated];
}
@end
