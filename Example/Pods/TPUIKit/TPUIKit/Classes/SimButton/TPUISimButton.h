//
//  TPSimButton.h
//  Pods-TPUIKit_Example
//
//  Created by Topredator on 2019/2/21.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TPUISimButtonIconPosition) {
    TPUISimButtonIconPositionDefault, // 系统默认样式
    TPUISimButtonIconPositionLeft, // icon在文本左边
    TPUISimButtonIconPositionRight, // icon在文本右边
    TPUISimButtonIconPositionTop, // icon在文本上边
    TPUISimButtonIconPositionBottom, // icon在文本下边
    TPUISimButtonIconPositionCenter // // icon在文本上边, 居中对齐
};

@interface TPUISimButton : UIButton
/// 图片 文本距离
@property (nonatomic, assign) CGFloat iconTextMargin;
/// 图片 文本的相对类型
@property (nonatomic, assign) TPUISimButtonIconPosition iconPosition;

/// 按钮点击扩展范围，设定值为单侧的px，上下左右都会加上这个扩展值
@property (nonatomic, assign) NSInteger extInteractEdge;
/// 自定义扩展上下左右的值
@property (nonatomic, assign) UIEdgeInsets extInteractInsets;

@end

