//
//  TPBlankView.h
//  TPUIKit
//
//  Created by Topredator on 2019/3/1.
//

#import <UIKit/UIKit.h>
#import "UIView+TPBlankView.h"

/// 空白展示页
@interface TPUIBlankView : UIView
@property (nonatomic, strong, nullable) UIView *contentView;
@property (nonatomic, assign) CGFloat topOffset UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets customEdgeInsets;

+ (instancetype)blankView;
+ (__kindof TPUIBlankView *)blankViewInView:(__kindof UIView *)view;

+ (instancetype)showInView:(__kindof UIView *)view animated:(BOOL)animated;
+ (instancetype)hideInView:(__kindof UIView *)view animated:(BOOL)animated;
- (void)showInView:(__kindof UIView *)view animated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;
- (void)setupSubviews;
@end

#pragma mark ==================  TPImageBlankView   ==================
@interface TPUIImageBlankView : TPUIBlankView
@property (nonatomic, strong, readonly) UIImageView *imageView;
@end
#pragma mark ==================  TPActivityBlankView   ==================
@interface TPUIActivityBlankView : TPUIBlankView
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activitiyView;
@end
#pragma mark ==================  TPUITextBlankView   ==================
@interface TPUITextBlankView : TPUIImageBlankView
/// 主标题
@property (nonatomic, strong, readonly) UILabel *textLabel;
/// 副标题
@property (nonatomic, strong, readonly) UILabel *subTextLabel;
/// 刷新按钮
@property (nonatomic, strong, readonly) UIButton *refreshButton;
/**
 设置刷新按钮

 @param title 刷新按钮标题, 如果为nil，隐藏按钮
 @param target 响应对象
 @param action 事件回调
 */
- (void)setRefreshTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 设置刷新按钮

 @param title 刷新按钮标题, 如果为nil，隐藏按钮
 @param block 事件回调
 */
- (void)setRefreshTitle:(NSString *)title actionBlock:(void(^)(void))block;
@end
