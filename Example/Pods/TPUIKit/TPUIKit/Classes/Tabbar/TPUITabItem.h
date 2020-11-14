//
//  TPUITabItem.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import <UIKit/UIKit.h>

//
//  TPUITabItem.h
//  TPUIKit
//
//  Created by Topredator on 2019/6/22.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TPUITabItemBadgeStyle) {
    TPUITabItemBadgeStyleNumber = 0, // 数字样式
    TPUITabItemBadgeStyleDot = 1, // 圆点样式
};

/**
 多选框item
 */
@interface TPUITabItem : UIButton
/// 在父视图中的下标
@property (nonatomic, assign) NSUInteger index;
/// 文字
@property (nonatomic, copy) NSString *title;
/// 文字颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 选中的文字颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
/// 文字font
@property (nonatomic, strong) UIFont *titleFont;
/// 选中的文字font
@property (nonatomic, strong) UIFont *titleSelectedFont;
/// 文字的宽
@property (nonatomic, assign, readonly) CGFloat titleWidth;
/// 图片
@property (nonatomic, strong) UIImage *image;
/// 选中时的图片
@property (nonatomic, strong) UIImage *selectedImage;
/// badge类型 2种：数字，小圆点
@property (nonatomic, assign) TPUITabItemBadgeStyle badgeStyle;

/**
 * 如果badgeStyle == XHXTabItemBadgeStyleNumber时，可设置此属性，显示badge值
 * badge > 99, 显示99+
 * badge <= 99 且 badge > 0, 显示具体数值
 * badge <= 0, 不显示
 */
@property (nonatomic, assign) NSInteger badge;
/// badge背景颜色
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
/// badge文字颜色
@property (nonatomic, strong) UIColor *badgeTitleColor;
/// badge文字font
@property (nonatomic, strong) UIFont *badgeTitleFont;

@property (nonatomic, assign) CGSize size;
/// 设置指示器的边距嵌入
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
/// 指示器的位置
@property (nonatomic, assign, readonly) CGRect indicatorFrame;
/**
 *  用于记录tabItem在缩放前的frame，
 *  在tabBar的属性itemFontChangeFollowContentScroll == YES时会用到
 */
@property (nonatomic, assign, readonly) CGRect frameWithOutTransform;

/// 设置 Image与title 水平居中
@property (nonatomic, assign, getter=isContentHorizontalCenter) BOOL contentHorizontalCenter;

/**
 *  设置Image和Title水平居中
 *
 *  @param verticalOffset   竖直方向的偏移量
 *  @param spacing          Image与Title的间距
 */
- (void)setContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                             spacing:(CGFloat)spacing;
/**
 *  设置数字Badge的位置
 *
 *  @param marginTop            与TabItem顶部的距离
 *  @param centerMarginRight    中心与TabItem右侧的距离
 *  @param titleHorizonalSpace  标题水平方向的空间
 *  @param titleVerticalSpace   标题竖直方向的空间
 */
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace;
/**
 *  设置小圆点Badge的位置
 *
 *  @param marginTop            与TabItem顶部的距离
 *  @param centerMarginRight    中心与TabItem右侧的距离
 *  @param sideLength           小圆点的边长
 */
- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength;
@end



