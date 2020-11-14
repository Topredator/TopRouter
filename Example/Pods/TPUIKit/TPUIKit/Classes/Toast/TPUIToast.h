//
//  TPUIToast.h
//  TPUIKit
//
//  Created by Topredator on 2019/2/22.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface TPUIToast : MBProgressHUD
/// 通过传入的字符串 获取展示的时间
+ (NSTimeInterval)durationForDisplayString:(NSString *)string;

/// 正在加载
+ (instancetype)showLoading:(NSString *)loading inView:(UIView *)view;
/// 展示成功信息
+ (instancetype)showSuccess:(NSString *)success inView:(UIView *)view;
+ (instancetype)showInfo:(NSString *)info inView:(UIView *)view;
/// 展示错误信息
+ (instancetype)showError:(NSError *)error inView:(UIView *)view;
/// 隐藏视图
+ (void)hideInView:(UIView *)view;

/// 加载视图，一般用于网络请求
+ (void)showLoading;
/// 加载视图，底部附带文字
+ (void)showLoadingWithString:(NSString *)string;
/// 显示成功提示框，自动隐藏
+ (void)showSuccess;
+ (void)showSuccessWithString:(NSString *)string;
/// 显示错误提示框，自动隐藏
+ (void)showError;
+ (void)showErrorWithString:(NSString *)string;
/// 显示纯文本提示框，自动隐藏
+ (void)showInfoWithString:(NSString *)string;
/// 隐藏提示框
+ (void)hideToast;
@end


