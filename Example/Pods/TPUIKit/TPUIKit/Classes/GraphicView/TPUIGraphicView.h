//
//  TPUIGraphicView.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <UIKit/UIKit.h>

/// icon 位于 文案的位置
typedef NS_ENUM(NSInteger, TPUIGraphicIconPositionType) {
    TPUIGraphicIconPositionTypeLeft, // 左
    TPUIGraphicIconPositionTypeRight, // 右
    TPUIGraphicIconPositionTypeTop, // 上
    TPUIGraphicIconPositionTypeBottom // 下
};

/// 图文结构视图
@interface TPUIGraphicView : UIView
/// 文案label 用于设置 字体
@property (nonatomic, strong, readonly) UILabel *titleLabel;
/// 边距
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/// 图文间距 默认4
@property (nonatomic, assign) CGFloat iconTextSpace;
/// icon位置类型
@property (nonatomic, assign) TPUIGraphicIconPositionType iconPositionType;
+ (instancetype)view;
- (void)configImage:(UIImage *)image text:(NSString *)text;
@end


