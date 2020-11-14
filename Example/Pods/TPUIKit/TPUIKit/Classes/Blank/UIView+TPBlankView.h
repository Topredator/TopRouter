//
//  UIView+TPBlankView.h
//  TPUIKit
//
//  Created by Topredator on 2019/3/1.
//

#import <UIKit/UIKit.h>

@class TPUIBlankView;
@class TPUIImageBlankView;
@class TPUIActivityBlankView;
@class TPUITextBlankView;

@interface UIView (TPBlankView)

/**
 显示系统activity指示器
 */
- (TPUIActivityBlankView *)tp_showActivityBlankView;

/**
 显示加载动画空白页
 */
- (TPUIImageBlankView *)tp_showLoadingBlankView;

/**
 显示加载动画空白页

 @param images 需要做动画的图片数组
 @param text 显示的文案
 @param size 图片的尺寸
 */
- (TPUIImageBlankView *)tp_showLoading:(NSArray <UIImage *>*)images text:(NSString *)text size:(CGSize)size;
/**
 显示带图片的空白页

 @param image 需要显示的图片
 */
- (TPUIImageBlankView *)tp_showBlankViewWithImage:(UIImage *)image;
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text;
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText;

/**
 显示带刷新按钮的空白页

 @param image 展示的图片
 @param text 展示的文案
 @param subText 展示的副文案
 @param title 刷新按钮的文案
 */
/**
 @param target 相应对象
 @param action 响应回调
 */
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText refreshTitle:(NSString *)title refreshTarget:(id)target action:(SEL)action;
/**
 @param refreshBlock 回调
 */
- (TPUITextBlankView *)tp_showTextBlankViewWithImage:(UIImage *)image text:(NSString *)text subText:(NSString *)subText refreshTitle:(NSString *)title refreshBlock:(void(^)(void))refreshBlock;

/**
 隐藏
 */
- (void)tp_hideBlankView;
- (void)tp_hideBlankViewAnimated:(BOOL)animated;
@end


