//
//  TPUITabbar.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import "TPUITabbar.h"
#import "TPUIBaseAccets.h"
@interface TPUITabbar () {
    CGFloat _scrollViewLastOffsetX;
}

/// 支持滚动时，使用scrollview
@property (nonatomic, strong) UIScrollView *scrollView;
/// 指示器视图
@property (nonatomic, strong) UIImageView *indicatorImageView;
/// 指示器的宽 是否适配文字宽度
@property (nonatomic, assign) BOOL indicatorWidthFixTitle;
// 切换item时，指示器是否动画
@property (nonatomic, assign) BOOL indicatorSwitchAnimated;
/// item是否匹配文字宽度
@property (nonatomic, assign) BOOL itemFitTextWidth;
/// 当Item匹配title的文字宽度时，左右留出的空隙，item的宽度 = 文字宽度 + spacing
@property (nonatomic, assign) CGFloat itemFitTextWidthSpacing;

// item的内容水平居中时，image与顶部的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterVerticalOffset;
// item的内容水平居中时，title与image的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterSpacing;

// 数字样式的badge相关属性
@property (nonatomic, assign) CGFloat numberBadgeMarginTop;
@property (nonatomic, assign) CGFloat numberBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat numberBadgeTitleHorizonalSpace;
@property (nonatomic, assign) CGFloat numberBadgeTitleVerticalSpace;

// 小圆点样式的badge相关属性
@property (nonatomic, assign) CGFloat dotBadgeMarginTop;
@property (nonatomic, assign) CGFloat dotBadgeCenterMarginRight;
@property (nonatomic, assign) CGFloat dotBadgeSideLength;

// 分割线相关属性
@property (nonatomic, strong) NSMutableArray *separatorLayers;
@property (nonatomic, strong) UIColor *itemSeparatorColor;
@property (nonatomic, assign) CGFloat itemSeparatorThickness;
@property (nonatomic, assign) CGFloat itemSeparatorLeading;
@property (nonatomic, assign) CGFloat itemSeparatorTrailing;

/// 是否为 竖直布局
@property (nonatomic, assign) BOOL isVertical;
/// 设置指示器的尺寸
@property (nonatomic, assign) CGSize indicatorSize;

@property (nonatomic, assign) TPUIIndicatorPosition indicatorPosition;
@end

@implementation TPUITabbar

#pragma mark ==================  Init methods  ==================
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _selectedItemIndex = 0;
    _itemTitleFont = [TPUIBaseAccets PFMediumFont:15];
    _itemTitleSelectedFont = [TPUIBaseAccets PFMediumFont:17];
    _itemTitleColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    _itemTitleSelectedColor = [UIColor colorWithRed:41 / 255.0 green:143 / 255.0 blue:237 / 255.0 alpha:1];
    
    _itemFontChangeFollowContentScroll = NO;
    _itemContentHorizontalCenter = YES;
    _itemColorChangeFollowContentScroll = YES;
    _indicatorScrollFollowContent = NO;
    
    _badgeTitleColor = [UIColor whiteColor];
    _badgeTitleFont = [UIFont systemFontOfSize:13];
    _badgeBackgroundColor = [UIColor redColor];
    
    _numberBadgeMarginTop = 2;
    _numberBadgeCenterMarginRight = 30;
    _numberBadgeTitleHorizonalSpace = 8;
    _numberBadgeTitleVerticalSpace = 2;
    
    _dotBadgeMarginTop = 5;
    _dotBadgeCenterMarginRight = 25;
    _dotBadgeSideLength = 10;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.indicatorImageView];
}
#pragma mark ==================  Public methods  ==================
- (void)setTitles:(NSArray<NSString *> *)titles {
    NSMutableArray *items = @[].mutableCopy;
    for (NSString *title in titles) {
        TPUITabItem *item = [TPUITabItem new];
        item.title = title;
        [items addObject:item];
    }
    self.items = items;
}

- (TPUITabItem *)selectedItem {
    if (self.selectedItemIndex == NSNotFound) {
        return nil;
    }
    return self.items[self.selectedItemIndex];
}
#pragma mark ==================  Indicator   ==================
- (void)setIndicatorSize:(CGSize)indicatorSize {
    _indicatorSize = indicatorSize;
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorImageView.backgroundColor = indicatorColor;
}
- (void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = indicatorImage;
}
- (void)setIndicatorRadius:(CGFloat)indicatorRadius {
    _indicatorRadius = indicatorRadius;
    self.indicatorImageView.clipsToBounds = YES;
    self.indicatorImageView.layer.cornerRadius = indicatorRadius;
}
- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets tapSwitchAnimated:(BOOL)animated {
    self.indicatorWidthFixTitle = NO;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = indicatorInsets;
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (void)setIndicatorPosition:(TPUIIndicatorPosition)indicatorPosition tapSwitchAnimated:(BOOL)animated {
    self.indicatorWidthFixTitle = NO;
    self.indicatorSwitchAnimated = animated;
    self.indicatorPosition = indicatorPosition;
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (void)setIndicatorSize:(CGSize)indicatorSize tapSwitchAnimated:(BOOL)animated {
    self.indicatorWidthFixTitle = NO;
    self.indicatorSwitchAnimated = animated;
    self.indicatorSize = indicatorSize;
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
- (void)setIndicatorWidthFixTextAndMarginTop:(CGFloat)top
                                marginBottom:(CGFloat)bottom
                           tapSwitchAnimated:(BOOL)animated {
    self.indicatorWidthFixTitle = YES;
    self.indicatorSwitchAnimated = animated;
    self.indicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    [self updateItemIndicatorInsets];
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}
/**
 更新指示器的嵌入  （设置frame）
 */
- (void)updateItemIndicatorInsets {
    for (TPUITabItem *item in self.items) {
        if (self.indicatorWidthFixTitle) { // 指示器的宽 适应文字
            CGRect frame = item.frameWithOutTransform;
            CGFloat space = (frame.size.width - item.titleWidth) / 2;
            item.indicatorInsets = UIEdgeInsetsMake(self.indicatorInsets.top, space, self.indicatorInsets.bottom, space);
        } else {
            if (self.indicatorPosition.width) {
                CGRect frame = item.frameWithOutTransform;
                TPUIIndicatorPosition position = self.indicatorPosition;
                UIEdgeInsets insets = UIEdgeInsetsMake(frame.size.height - position.height - position.bottom, (frame.size.width - position.width) / 2, position.bottom, (frame.size.width - position.width) / 2);
                item.indicatorInsets = insets;
                continue;
            }
            if (self.indicatorSize.width) {
                CGRect frame = item.frameWithOutTransform;
                CGSize size = self.indicatorSize;
                UIEdgeInsets insets = UIEdgeInsetsMake(frame.size.height - size.height, (frame.size.width - size.width) / 2, 0, (frame.size.width - size.width) / 2);
                item.indicatorInsets = insets;
                continue;
            }
            item.indicatorInsets = self.indicatorInsets;
        }
    }
}
#pragma mark ==================  ItemTitle   ==================
- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:itemTitleColor];
}

- (void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor {
    _itemTitleSelectedColor = itemTitleSelectedColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:itemTitleSelectedColor];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    if (self.itemFontChangeFollowContentScroll) {
        // item字体支持平滑切换，更新每个item的scale
        [self updateItemsScaleIfNeeded];
    } else {
        // item字体不支持平滑切换，更新item的字体
        if (self.itemTitleSelectedFont) {
            // 设置了选中字体，则只更新未选中的item
            for (TPUITabItem *item in self.items) {
                if (!item.selected) {
                    item.titleFont = itemTitleFont;
                }
            }
        } else {
            // 未设置选中字体，更新所有item
            [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:itemTitleFont];
        }
    }
    
    if (self.itemFitTextWidth) {
        // 如果item的宽度是匹配文字的，更新item的位置
        [self updateItemsFrame];
    }
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)setItemTitleSelectedFont:(UIFont *)itemTitleSelectedFont {
    _itemTitleSelectedFont = itemTitleSelectedFont;
    self.selectedItem.titleFont = itemTitleSelectedFont;
    [self updateItemsScaleIfNeeded];
}

- (void)setItemFontChangeFollowContentScroll:(BOOL)itemFontChangeFollowContentScroll {
    _itemFontChangeFollowContentScroll = itemFontChangeFollowContentScroll;
    [self updateItemsScaleIfNeeded];
}

- (void)updateItemsScaleIfNeeded {
    if (self.itemTitleSelectedFont && self.itemFontChangeFollowContentScroll && self.itemTitleSelectedFont.pointSize != self.itemTitleFont.pointSize) {
        // 全部置为 选中字体
        [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:self.itemTitleSelectedFont];
        // 遍历 然后 改变没选中的 transform
        for (TPUITabItem *item in self.items) {
            if (!item.selected) {
                item.transform = CGAffineTransformMakeScale([self itemTitleUnselectedFontScale], [self itemTitleUnselectedFontScale]);
            }
        }
    }
}
#pragma mark ==================  Item Content  ==================
- (void)setItemContentHorizontalCenter:(BOOL)itemContentHorizontalCenter {
    _itemContentHorizontalCenter = itemContentHorizontalCenter;
    if (itemContentHorizontalCenter) {
        [self setItemContentHorizontalCenterWithVerticalOffset:5 spacing:5];
    } else {
        self.itemContentHorizontalCenterVerticalOffset = 0;
        self.itemContentHorizontalCenterSpacing = 0;
        [self.items makeObjectsPerformSelector:@selector(setContentHorizontalCenter:) withObject:@(NO)];
    }
}

- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing {
    _itemContentHorizontalCenter = YES;
    self.itemContentHorizontalCenterVerticalOffset = verticalOffset;
    self.itemContentHorizontalCenterSpacing = spacing;
    for (TPUITabItem *item in self.items) {
        [item setContentHorizontalCenterWithVerticalOffset:verticalOffset spacing:spacing];
    }
}
#pragma mark ==================  Badge   ==================
- (void)setBadgeBackgroundColor:(UIColor *)badgeBackgroundColor {
    _badgeBackgroundColor = badgeBackgroundColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeBackgroundColor:) withObject:badgeBackgroundColor];
}

- (void)setBadgeTitleColor:(UIColor *)badgeTitleColor {
    _badgeTitleColor = badgeTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleColor:) withObject:badgeTitleColor];
}

- (void)setBadgeTitleFont:(UIFont *)badgeTitleFont {
    _badgeTitleFont = badgeTitleFont;
    [self.items makeObjectsPerformSelector:@selector(setBadgeTitleFont:) withObject:badgeTitleFont];
}

- (void)setNumberBadgeMarginTop:(CGFloat)marginTop
              centerMarginRight:(CGFloat)centerMarginRight
            titleHorizonalSpace:(CGFloat)titleHorizonalSpace
             titleVerticalSpace:(CGFloat)titleVerticalSpace {
    self.numberBadgeMarginTop = marginTop;
    self.numberBadgeCenterMarginRight = centerMarginRight;
    self.numberBadgeTitleHorizonalSpace = titleHorizonalSpace;
    self.numberBadgeTitleVerticalSpace = titleVerticalSpace;
    
    for (TPUITabItem *item in self.items) {
        [item setNumberBadgeMarginTop:marginTop
                    centerMarginRight:centerMarginRight
                  titleHorizonalSpace:titleHorizonalSpace
                   titleVerticalSpace:titleVerticalSpace];
    }
}

- (void)setDotBadgeMarginTop:(CGFloat)marginTop
           centerMarginRight:(CGFloat)centerMarginRight
                  sideLength:(CGFloat)sideLength {
    self.dotBadgeMarginTop = marginTop;
    self.dotBadgeCenterMarginRight = centerMarginRight;
    self.dotBadgeSideLength = sideLength;
    
    for (TPUITabItem *item in self.items) {
        [item setDotBadgeMarginTop:marginTop
                 centerMarginRight:centerMarginRight
                        sideLength:sideLength];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
    [self updateAllUI];
}
- (void)setItems:(NSArray<TPUITabItem *> *)items {
    _selectedItemIndex = NSNotFound;
    // 将老的item 从superview上删除
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _items = [items copy];
    
    // 初始化每个item
    for (TPUITabItem *item in self.items) {
        item.titleColor = self.itemTitleColor;
        item.titleSelectedColor = self.itemTitleSelectedColor;
        item.titleFont = self.itemTitleFont;
        item.titleSelectedFont = self.itemTitleSelectedFont;
        [item setContentHorizontalCenterWithVerticalOffset:5 spacing:5];
        
        item.badgeTitleColor = self.badgeTitleColor;
        item.badgeTitleFont = self.badgeTitleFont;
        item.badgeBackgroundColor = self.badgeBackgroundColor;
        
        [item setNumberBadgeMarginTop:self.numberBadgeMarginTop centerMarginRight:self.numberBadgeCenterMarginRight titleHorizonalSpace:self.numberBadgeTitleHorizonalSpace titleVerticalSpace:self.numberBadgeTitleVerticalSpace];
        [item setDotBadgeMarginTop:self.dotBadgeMarginTop centerMarginRight:self.dotBadgeCenterMarginRight sideLength:self.dotBadgeSideLength];
        
        [item addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        // 添加到scrollview上
        [self.scrollView addSubview:item];
        
    }
    [self.scrollView bringSubviewToFront:self.indicatorImageView];
    // 更新UI
    [self updateItemsScaleIfNeeded];
    [self updateAllUI];
}

/**
 更新所有的UI
 */
- (void)updateAllUI {
    // item的frame
    [self updateItemsFrame];
    [self updateItemIndicatorInsets];
    // 指示器的frame
    [self updateIndicatorFrameWithIndex:self.selectedItemIndex];
}

- (void)updateItemsFrame {
    // items为空
    if (!self.items.count) return;
    if (self.isVertical) { // 如果竖直布局
        CGFloat y = self.leadAndTrailSpace;
        if (!self.scrollView.scrollEnabled) { // 如果不支持滚动
            self.itemHeight = ceil((self.frame.size.height - 2 * self.leadAndTrailSpace) / self.items.count);
        }
        for (NSUInteger index = 0; index < self.items.count; index ++) {
            TPUITabItem *item = self.items[index];
            item.frame = CGRectMake(0, y, self.frame.size.width, self.itemHeight);
            item.index = index;
            y += self.itemHeight;
        }
        // 设置scrollview的contentSize
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, MAX(y + self.leadAndTrailSpace, self.scrollView.frame.size.height));
    } else { // 水平布局
        if (self.scrollView.scrollEnabled) { // 支持滚动
            CGFloat x = self.leadAndTrailSpace;
            for (NSUInteger index = 0; index < self.items.count; index ++) {
                TPUITabItem *item = self.items[index];
                CGFloat width = 0;
                // itemWidth设置过 为固定值
                if (self.itemWidth) width = self.itemWidth;
                // item的宽度为根据字体大小和spacing进行适配
                if (self.itemFitTextWidth) width = MAX(item.titleWidth + self.itemFitTextWidthSpacing, self.itemMinWidth);
                
                item.frame = CGRectMake(x, 0, width, self.frame.size.height);
                item.index = index;
                x += width;
            }
            self.scrollView.contentSize = CGSizeMake(MAX(x + self.leadAndTrailSpace, self.scrollView.frame.size.width), self.scrollView.frame.size.height);
        } else { // 不支持滚动
            CGFloat x = self.leadAndTrailSpace;
            CGFloat allItemsWidth = self.frame.size.width - self.leadAndTrailSpace * 2;
            self.itemWidth = allItemsWidth / self.items.count;
            // 四舍五入，取整，防止字体模糊
            self.itemWidth = floorf(self.itemWidth + 0.5f);
            
            for (NSUInteger index = 0; index < self.items.count; index ++) {
                TPUITabItem *item = self.items[index];
                item.frame = CGRectMake(x, 0, self.itemWidth, self.frame.size.height);
                item.index = index;
                x += self.itemWidth;
            }
            self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        }
    }
}



- (void)updateIndicatorFrameWithIndex:(NSUInteger)index {
    if (!self.items.count || index == NSNotFound) {
        self.indicatorImageView.frame = CGRectZero;
        return;
    }
    TPUITabItem *item = self.items[index];
    self.indicatorImageView.frame = item.indicatorFrame;
}

- (void)tabItemClicked:(TPUITabItem *)item {
    self.selectedItemIndex = item.index;
}

- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex {
    if (selectedItemIndex == _selectedItemIndex || selectedItemIndex >= self.items.count || !self.items.count) {
        return;
    }
    // 是否可以选中,如果不能，直接返回
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbar:shouldSelectedItemAtIndex:)]) {
        BOOL isShould = [self.delegate tabbar:self shouldSelectedItemAtIndex:selectedItemIndex];
        if (!isShould) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbar:willSelectItemAtIndex:)]) {
        [self.delegate tabbar:self willSelectItemAtIndex:selectedItemIndex];
    }
    if (_selectedItemIndex != NSNotFound) {
        TPUITabItem *oldItem = self.items[_selectedItemIndex];
        oldItem.selected = NO;
        if (self.itemFontChangeFollowContentScroll) {
            oldItem.transform = CGAffineTransformMakeScale([self itemTitleUnselectedFontScale], [self itemTitleUnselectedFontScale]);
        } else {
            oldItem.titleFont = self.itemTitleFont;
        }
    }
    
    TPUITabItem *newItem = self.items[selectedItemIndex];
    newItem.selected = YES;
    if (self.itemFontChangeFollowContentScroll) {
        newItem.transform = CGAffineTransformMakeScale(1, 1);
    } else {
        if (self.itemTitleSelectedFont) {
            newItem.titleFont = self.itemTitleSelectedFont;
        }
    }
    
    if (self.indicatorSwitchAnimated && _selectedItemIndex != NSNotFound) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateIndicatorFrameWithIndex:selectedItemIndex];
        }];
    } else {
        [self updateIndicatorFrameWithIndex:selectedItemIndex];
    }
    
    _selectedItemIndex = selectedItemIndex;
    
    // 如果tabbar支持滚动，将选中的item放到tabbar的中央
    [self setSelectedItemMoveToTabbarCenter];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbar:didSelectedItemAtIndex:)]) {
        [self.delegate tabbar:self didSelectedItemAtIndex:selectedItemIndex];
    }
}

- (void)setTabItemsVerticalLayout {
    self.isVertical = YES;
    if (self.items.count == 0) {
        return;
    }
    [self updateAllUI];
}

- (void)setTabItemsVerticalLayoutWithItemHeight:(CGFloat)height {
    self.isVertical = YES;
    if (self.items.count == 0) {
        return;
    }
    self.scrollView.scrollEnabled = YES;
    self.itemHeight = height;
    [self updateAllUI];
}
/**
 把选中的item 移动到tabbar中央位置
 */
- (void)setSelectedItemMoveToTabbarCenter {
    // 不支持滚动 或者 竖直布局 不显示
    if (!self.scrollView.scrollEnabled || self.isVertical) {
        return;
    }
    // 修改偏移量
    CGFloat offsetX = self.selectedItem.center.x - self.scrollView.frame.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
/**
 *  获取未选中字体与选中字体大小的比例
 */
- (CGFloat)itemTitleUnselectedFontScale {
    if (_itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / _itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}
- (void)setScrollEnabledAndItemWidth:(CGFloat)width {
    self.scrollView.scrollEnabled = YES;
    self.itemWidth = width;
    self.itemFitTextWidth = NO;
    self.itemFitTextWidthSpacing = 0;
    self.itemMinWidth = 0;
    [self updateItemsFrame];
}
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing {
    [self setScrollEnabledAndItemFitTextWidthWithSpacing:spacing minWidth:0];
}
- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing minWidth:(CGFloat)minWidth {
    self.scrollView.scrollEnabled = YES;
    self.itemFitTextWidth = YES;
    self.itemFitTextWidthSpacing = spacing;
    self.itemWidth = 0;
    self.itemMinWidth = minWidth;
    [self updateItemsFrame];
}

- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView {
    // scrollview 的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    // scrollview 的宽度
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    NSUInteger leftIndex = offsetX / scrollViewWidth;
    NSUInteger rightIndex = leftIndex + 1;
    
    TPUITabItem *leftItem = self.items[leftIndex];
    TPUITabItem *rightItem = nil;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    // 如果 支持文字大小 跟随content的拖动进行变化，并且 未选中和已选中字体大小不一致
    if (self.itemFontChangeFollowContentScroll && [self itemTitleUnselectedFontScale] != 1.0) {
        // 计算文字大小的差值
        CGFloat diff = [self itemTitleUnselectedFontScale] - 1;
        leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale *diff + 1);
        rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale *diff + 1);
    }
    //  如果 支持 文字颜色 跟随内容拖动进行变化
    if (self.itemColorChangeFollowContentScroll) {
        // 获取rgb各项数值
        CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
        CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
        
        [self.itemTitleColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
        [self.itemTitleSelectedColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
        
        // 获取选中和未选中状态的颜色差值
        CGFloat redDiff = selectedRed - normalRed;
        CGFloat greenDiff = selectedGreen - normalGreen;
        CGFloat blueDiff = selectedBlue - normalBlue;
        CGFloat alphaDiff = selectedAlpha - normalAlpha;
        // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
        leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                        green:leftScale * greenDiff + normalGreen
                                                         blue:leftScale * blueDiff + normalBlue
                                                        alpha:leftScale * alphaDiff + normalAlpha];
        rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed
                                                         green:rightScale * greenDiff + normalGreen
                                                          blue:rightScale * blueDiff + normalBlue
                                                         alpha:rightScale * alphaDiff + normalAlpha];
    }
    
    // 如果指示器 跟随内容拖动进行变化
    if (self.indicatorScrollFollowContent) {
        if (self.indicatorAnimationStyle == TPUITabbarIndicatorAnimationTypeDefault) {
            CGRect frame = self.indicatorImageView.frame;
            
            // 横坐标x的变化
            CGFloat xDiff = rightItem.indicatorFrame.origin.x - leftItem.indicatorFrame.origin.x;
            frame.origin.x = leftItem.indicatorFrame.origin.x + rightScale * xDiff;
            // 宽度的变化
            CGFloat widthDiff = rightItem.indicatorFrame.size.width - leftItem.indicatorFrame.size.width;
            frame.size.width = leftItem.indicatorFrame.size.width + rightScale * widthDiff;
            self.indicatorImageView.frame = frame;
            [self.indicatorImageView.superview layoutIfNeeded];
        } else if (self.indicatorAnimationStyle == TPUITabbarIndicatorAnimationTypeElasticity) {
            NSUInteger page = offsetX / scrollViewWidth;
            // 当前下标、目标下标
            NSUInteger currentIndex = NSNotFound, targetIndex = NSNotFound;
            // 比例  0-1之间
            CGFloat scale = offsetX / scrollViewWidth - page;
            if (_scrollViewLastOffsetX < offsetX) { // 左滑
                currentIndex = page;
                targetIndex = page + 1;
                scale = scale * 2;
            } else if (_scrollViewLastOffsetX > offsetX) { // 右滑
                currentIndex = page + 1;
                targetIndex = page;
                scale = (1 - scale) * 2;
            } else {
                return;
            }
            if (targetIndex >= self.items.count) {
                return;
            }
            TPUITabItem *currentItem = self.items[currentIndex];
            TPUITabItem *targetItem = self.items[targetIndex];
            
            CGFloat currentItemWidth = currentItem.frameWithOutTransform.size.width;
            CGFloat targetItemWidth = targetItem.frameWithOutTransform.size.width;
            
            if (targetIndex > currentIndex) { // 左滑过程中
                if (scale < 1) { // 小于半个屏幕
                    CGFloat addition = scale * (CGRectGetMaxX(targetItem.indicatorFrame) - CGRectGetMaxX(currentItem.indicatorFrame));
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x width:currentItem.indicatorFrame.size.width + addition];
                } else if (scale > 1) { // 大于半个屏幕
                    scale = scale - 1;
                    CGFloat addition = scale * (targetItem.indicatorFrame.origin.x - currentItem.indicatorFrame.origin.x);
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x + addition width:currentItemWidth + targetItemWidth - addition - currentItem.indicatorInsets.left - targetItem.indicatorInsets.right];
                }
            } else { // 右滑过程中
                if (scale < 1) { // 小于半个屏幕
                    CGFloat addition = scale * (currentItem.indicatorFrame.origin.x - targetItem.indicatorFrame.origin.x);
                    [self setIndicatorX:currentItem.indicatorFrame.origin.x - addition width:currentItem.indicatorFrame.size.width + addition];
                } else if (scale > 1) { // 大于半个屏幕
                    scale = scale - 1;
                    CGFloat addition = (1 - scale) * (CGRectGetMaxX(currentItem.indicatorFrame) - CGRectGetMaxX(targetItem.indicatorFrame));
                    [self setIndicatorX:targetItem.indicatorFrame.origin.x width:targetItem.indicatorFrame.size.width + addition];
                }
            }
            _scrollViewLastOffsetX = offsetX;
        }
    }
}

/**
 通过 横坐标与宽度 设置指示器frame
 */
- (void)setIndicatorX:(CGFloat)x width:(CGFloat)width {
    CGRect frame = self.indicatorImageView.frame;
    frame.origin.x = x;
    frame.size.width = width;
    self.indicatorImageView.frame = frame;
}

#pragma mark ==================  Lazy methods  ==================
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}
- (UIImageView *)indicatorImageView {
    if (!_indicatorImageView) {
        _indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _indicatorImageView;
}
@end
