//
//  TPUITabbar.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import <UIKit/UIKit.h>
#import "TPUITabItem.h"

// 主要是确定指示器的位置及尺寸 (居中显示)
typedef struct {
    CGFloat bottom, width, height;
} TPUIIndicatorPosition;

CG_INLINE TPUIIndicatorPosition TPUIIndicatorPositionMake(CGFloat bottom, CGFloat width, CGFloat height) {
    TPUIIndicatorPosition position = {bottom, width, height};
    return position;
}

typedef NS_ENUM(NSInteger, TPUITabbarIndicatorAnimationType) {
    TPUITabbarIndicatorAnimationTypeDefault = 0, // 默认
    TPUITabbarIndicatorAnimationTypeElasticity, // 弹性动画
};

@class TPUITabbar;
@protocol TPUITabbarDelegate <NSObject>
@optional
/**
 是否能切换到指定index
 */
- (BOOL)tabbar:(TPUITabbar *)tabbar shouldSelectedItemAtIndex:(NSInteger)index;
/*
 * 将要切换到指定index
 */
- (void)tabbar:(TPUITabbar *)tabbar willSelectItemAtIndex:(NSInteger)index;
/*
 * 已经切换到指定index
 */
- (void)tabbar:(TPUITabbar *)tabbar didSelectedItemAtIndex:(NSInteger)index;
@end

/// 多选框
@interface TPUITabbar : UIView
@property (nonatomic, weak) id <TPUITabbarDelegate> delegate;
@property (nonatomic, copy) NSArray <TPUITabItem *> *items;
/// 指示器颜色
@property (nonatomic, strong) UIColor *indicatorColor;
/// 指示器图片
@property (nonatomic, strong) UIImage *indicatorImage;
/// 指示器圆角
@property (nonatomic, assign) CGFloat indicatorRadius;

/// 标题颜色
@property (nonatomic, strong) UIColor *itemTitleColor;
/// 选中时标题颜色
@property (nonatomic, strong) UIColor *itemTitleSelectedColor;
/// 标题字体
@property (nonatomic, strong) UIFont *itemTitleFont;
/// 选中时标题字体
@property (nonatomic, strong) UIFont *itemTitleSelectedFont;
/// badge背景颜色
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
/// badge标题颜色
@property (nonatomic, strong) UIColor *badgeTitleColor;
/// badge标题字体
@property (nonatomic, strong) UIFont *badgeTitleFont;

/// tabbar边缘 与第一个和最后一个item的距离
@property (nonatomic, assign) CGFloat leadAndTrailSpace;
/// 选中的item下标
@property (nonatomic, assign) NSUInteger selectedItemIndex;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemMinWidth;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
/// 指示器的动画类型
@property (nonatomic, assign) TPUITabbarIndicatorAnimationType indicatorAnimationStyle;
/**
 *  拖动内容视图时，item的字体是否根据拖动位置显示渐变效果，默认为NO
 */
@property (nonatomic, assign, getter = isItemFontChangeFollowContentScroll) BOOL itemFontChangeFollowContentScroll;
/**
 *  拖动内容视图时，item的颜色是否根据拖动位置显示渐变效果，默认为YES
 */
@property (nonatomic, assign, getter = isItemColorChangeFollowContentScroll) BOOL itemColorChangeFollowContentScroll;
/**
 *  拖动内容视图时，item的选中指示器是否随contentView滑动而移动，默认为NO
 */
@property (nonatomic, assign, getter = isIndicatorScrollFollowContent) BOOL indicatorScrollFollowContent;
/**
 *  将Image和Title设置为水平居中，默认为YES
 */
@property (nonatomic, assign, getter = isItemContentHorizontalCenter) BOOL itemContentHorizontalCenter;



/**
 返回选中的item
 */
- (TPUITabItem *)selectedItem;

/**
 根据titles创建items
 */
- (void)setTitles:(NSArray <NSString *>*)titles;
/**
 *  设置tabItem的选中背景，这个背景可以是一个横条。
 *  此方法与setIndicatorWidthFixText方法互斥，后调用者生效
 *
 *  @param indicatorInsets       选中背景的insets
 *  @param animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets tapSwitchAnimated:(BOOL)animated;
/**
 *  设置tabItem的选中指示器的size
 *  此方法与setIndicatorWidthFixText方法互斥，后调用者生效
 *
 *  @param indicatorSize       选中指示器的size
 *  @param animated     点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorSize:(CGSize)indicatorSize tapSwitchAnimated:(BOOL)animated __attribute__((deprecated("已过期, 建议使用setIndicatorPosition:tapSwitchAnimated:替换")));


/**
 设置tabItem的选中指示器的  位置 及 尺寸
 
 @param indicatorPosition 指示器居中显示, 固定宽高，bottom指指示器离底部距离
 @param animated 点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorPosition:(TPUIIndicatorPosition)indicatorPosition tapSwitchAnimated:(BOOL)animated;

/**
 *  设置指示器的宽度根据title宽度来匹配
 *  此方法与setIndicatorInsets方法互斥，后调用者生效
 
 *  @param top 指示器与tabItem顶部的距离
 *  @param bottom 指示器与tabItem底部的距离
 *  @param animated 点击item进行背景切换的时候，是否支持动画
 */
- (void)setIndicatorWidthFixTextAndMarginTop:(CGFloat)top
                                marginBottom:(CGFloat)bottom
                           tapSwitchAnimated:(BOOL)animated;
/**
 *  将tabItem的image和title设置为居中，并且调整其在竖直方向的位置
 *
 *  @param verticalOffset  竖直方向的偏移量
 *  @param spacing         image和title的距离
 */
- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing;

/**
 *  设置数字Badge的位置与大小。
 *  默认marginTop = 2，centerMarginRight = 30，titleHorizonalSpace = 8，titleVerticalSpace = 2。
 *
 *  @param marginTop            与TabItem顶部的距离，默认为：2
 *  @param centerMarginRight    中心与TabItem右侧的距离，默认为：30
 *  @param titleHorizonalSpace  标题水平方向的空间，默认为：8
 *  @param titleVerticalSpace   标题竖直方向的空间，默认为：2
 */
- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace;
/**
 *  设置小圆点Badge的位置与大小。
 *  默认marginTop = 5，centerMarginRight = 25，sideLength = 10。
 *
 *  @param marginTop            与TabItem顶部的距离，默认为：5
 *  @param centerMarginRight    中心与TabItem右侧的距离，默认为：25
 *  @param sideLength           小圆点的边长，默认为：10
 */
- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength;

/**
 *  设置tabBar为竖向且支持滚动，tabItem的高度根据tabBar高度和leadAndTrailSpace属性计算
 *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 */
- (void)setTabItemsVerticalLayout;

/**
 *  设置tabBar为竖向且支持滚动，一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 *  一旦调用此方法，所有跟横向相关的效果将失效，例如内容视图滚动，指示器切换动画等
 *
 *  @param height 单个tabItem的高度
 */
- (void)setTabItemsVerticalLayoutWithItemHeight:(CGFloat)height;

/**
 *  设置tabBar可以左右滑动
 *  此方法与setScrollEnabledAndItemFitTextWidthWithSpacing这个方法是两种模式，哪个后调用哪个生效
 *
 *  @param width 每个tabItem的宽度
 */
- (void)setScrollEnabledAndItemWidth:(CGFloat)width;
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing;
/**
 *  设置tabBar可以左右滑动，并且item的宽度根据标题的宽度来匹配
 *  此方法与setScrollEnabledAndItemWidth这个方法是两种模式，哪个后调用哪个生效
 *
 *  @param spacing item的宽度 = 文字宽度 + spacing
 *  @param minWidth item的最小宽度
 */
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing
                                              minWidth:(CGFloat)minWidth;

/**
 *  当YPTabBar所属的YPTabBarController内容视图支持拖动切换时，
 *  此方法用于同步内容视图scrollView拖动的偏移量，以此来改变YPTabBar内控件的状态
 */
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView;
@end


