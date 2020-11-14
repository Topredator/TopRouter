//
//  TPPageControl.h
//  TPUIKit
//
//  Created by Topredator on 2020/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TPPageControl;

@protocol TPPageControlDelegate <NSObject>
@optional
- (void)tp_pageControl:(TPPageControl *)pageControl didSelectedPageAtIndex:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, TPPageControlPosition) {
    TPPageControlPositionCenter, // 居中展示
    TPPageControlPositionLeft, // 左边
    TPPageControlPositionRight // 右侧
};

/// 自定义pageControl
@interface TPPageControl : UIControl
/// 当前页码下标 默认: 0
@property (nonatomic, assign) NSInteger currentPage;
/// 页码总数 默认:0
@property (nonatomic, assign) NSInteger numberOfPages;
/// 单个 是否隐藏整个控件  默认:NO
@property (nonatomic, assign) BOOL hideForSinglePage;
/// 圆点 间距 默认: 8
@property (nonatomic, assign) CGFloat spaceBetweenPages;
/// 当前选中图片
@property (nonatomic, strong) UIImage *currentPageImage;
/// 默认图片
@property (nonatomic, strong) UIImage *pageImage;
/// 展示位置枚举，默认居中展示
@property (nonatomic, assign) TPPageControlPosition position;
/// 点击操作代理
@property (nonatomic, weak) id <TPPageControlDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
