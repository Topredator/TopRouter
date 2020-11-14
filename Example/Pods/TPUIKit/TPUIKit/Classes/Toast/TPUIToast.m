//
//  TPUIToast.m
//  TPUIKit
//
//  Created by Topredator on 2019/2/22.
//

#import "TPUIToast.h"

#define kTPWindow [UIApplication sharedApplication].keyWindow
#import "TPUIToastAccets.h"

@implementation TPUIToast

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.contentColor = [UIColor whiteColor];
        self.detailsLabel.font = [UIFont systemFontOfSize:14];
        self.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        self.animationType = MBProgressHUDAnimationFade;
        self.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        self.bezelView.layer.cornerRadius = 10;
    }
    return self;
}

/// 通过传入的字符串 获取展示的时间
+ (NSTimeInterval)durationForDisplayString:(NSString *)string {
    return MAX(1.8, MIN((double)(string.length) * 0.1 + 0.5, 5.0));
}
/// 正在加载
+ (instancetype)showLoading:(NSString *)loading inView:(UIView *)view {
    if (!view) return nil;
    [self hideInView:view];
    TPUIToast *toast = [TPUIToast showHUDAddedTo:view animated:YES];
    toast.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [self fetchToastImageView];
    toast.customView = imageView;
    toast.square = YES;
    toast.detailsLabel.text = loading;
    [imageView startAnimating];
    return toast;
}
/// 展示成功信息
+ (instancetype)showSuccess:(NSString *)success inView:(UIView *)view {
    if (!view) return nil;
    [self hideInView:view];
    TPUIToast *toast = [TPUIToast showHUDAddedTo:view animated:YES];
    toast.mode = MBProgressHUDModeCustomView;
    toast.square = YES;
    toast.customView = [[UIImageView alloc] initWithImage:[TPUIToastAccets imageName:@"iconSuccess"]];
    toast.detailsLabel.text = success ?: @"";
    [toast hideAnimated:YES afterDelay:[self durationForDisplayString:success ?: @""]];
    return toast;
}
+ (instancetype)showInfo:(NSString *)info inView:(UIView *)view {
    if (!view) return nil;
    [self hideInView:view];
    TPUIToast *toast = [TPUIToast showHUDAddedTo:view animated:YES];
    toast.mode = MBProgressHUDModeText;
    toast.detailsLabel.text = info ?: @"";
    [toast hideAnimated:YES afterDelay:[self durationForDisplayString:info ?: @""]];
    return toast;
}
/// 展示错误信息
+ (instancetype)showError:(NSError *)error inView:(UIView *)view {
    if (!view) return nil;
    [self hideInView:view];
    NSString *message = error.localizedDescription;
    if (message) {
        return [self showInfo:message inView:view];
    }
    return nil;
}
/// 隐藏视图
+ (void)hideInView:(UIView *)view {
    if (view) {
        [TPUIToast hideHUDForView:view animated:YES];
    }
}


/// 加载视图，一般用于网络请求
+ (void)showLoading {
    [self showLoadingWithString:nil];
}
/// 加载视图，底部附带文字
+ (void)showLoadingWithString:(NSString *)string {
    [self hideToast];
    TPUIToast *toast = [TPUIToast showHUDAddedTo:kTPWindow animated:YES];
    toast.minSize = CGSizeMake(120, 120);
    toast.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [self fetchToastImageView];
    toast.customView = imageView;
    toast.square = YES;
    if (string) {
        toast.detailsLabel.text = string;
        toast.detailsLabel.textColor = UIColor.whiteColor;
        toast.detailsLabel.font = [UIFont systemFontOfSize:14];
    }
    [imageView startAnimating];
}
/// 显示成功提示框，自动隐藏
+ (void)showSuccess {
    [self hideToast];
    [self showText:nil icon:@"iconSuccess" view:nil];
}
+ (void)showSuccessWithString:(NSString *)string {
    [self hideToast];
    [self showText:string icon:@"iconSuccess" view:nil];
}
/// 显示错误提示框，自动隐藏
+ (void)showError {
    [self hideToast];
    [self showText:nil icon:@"iconError" view:nil];
}
+ (void)showErrorWithString:(NSString *)string {
    [self hideToast];
    [self showText:string icon:@"iconError" view:nil];
}
/// 显示纯文本提示框，自动隐藏
+ (void)showInfoWithString:(NSString *)string {
    [self hideToast];
    if (!string) return;
    TPUIToast *toast = [TPUIToast showHUDAddedTo:kTPWindow animated:YES];
    toast.margin = 18;
    toast.mode = MBProgressHUDModeText;
    toast.detailsLabel.textColor = UIColor.whiteColor;
    toast.detailsLabel.text = string ?: @"";
    toast.detailsLabel.font = [UIFont systemFontOfSize:14];
    [toast hideAnimated:YES afterDelay:[self durationForDisplayString:string ?: @""]];
}
/// 隐藏提示框
+ (void)hideToast {
    [self hideHUDForView:kTPWindow animated:YES];
}

#pragma mark ==================  private method  ==================
+ (void)showText:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (!view) {
        view = kTPWindow;
    }
    TPUIToast *toast = [TPUIToast showHUDAddedTo:view animated:YES];
    toast.minSize = text.length ? CGSizeMake(160, 113) : CGSizeMake(120, 120);
    toast.detailsLabel.text = text ?: @"";
    toast.detailsLabel.textColor = UIColor.whiteColor;
    if (icon) {
        toast.customView = [[UIImageView alloc] initWithImage:[TPUIToastAccets imageName:icon]];
        toast.mode = MBProgressHUDModeCustomView;
    }
    /// 隐藏时，从父视图上移除
    toast.removeFromSuperViewOnHide = YES;
    [toast hideAnimated:YES afterDelay:[self durationForDisplayString:text ?: @""]];
}

+ (UIImageView *)fetchToastImageView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 36)];
    NSMutableArray *images = [NSMutableArray array];
    for (NSInteger i = 0; i <= 49; i++) {
        [images addObject:[TPUIToastAccets imageName:[NSString stringWithFormat:@"loading1_000%02ld", i]]];
    }
    imageView.animationImages = images;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.animationDuration = 3.f;
    imageView.animationRepeatCount = 0;
    return imageView;
}

@end
