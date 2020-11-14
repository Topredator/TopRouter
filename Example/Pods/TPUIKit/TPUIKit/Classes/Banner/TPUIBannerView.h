//
//  TPUIBannerView.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <UIKit/UIKit.h>
#import "TPUIBannerPageView.h"

@class TPUIBannerView;
@protocol TPUIBannerViewDelegate <UIScrollViewDelegate>
/// banner的页面个数
- (NSInteger)numberOfPagesForBannerView:(TPUIBannerView *)bannerView;
/// banner的页面
- (TPUIBannerPageView *)bannerView:(TPUIBannerView *)banner viewForPageIndex:(NSInteger)pageIndex;
@optional
/// 分页被收回重用时会触发
- (void)bannerView:(TPUIBannerView *)bannerView didPreparedForReuseAtPageIndex:(NSInteger)pageIndex;
- (void)bannerView:(TPUIBannerView *)bannerView didShowPageViewAtIndex:(NSInteger)pageIndex;
- (void)bannerView:(TPUIBannerView *)bannerView didSelectedAtPageIndex:(NSInteger)pageIndex;
- (void)bannerView:(TPUIBannerView *)bannerView currentPageIndexDidChanged:(NSInteger)pageIndex;
/// 是否可以点击, 默认不能点击
- (BOOL)bannerView:(TPUIBannerView *)bannerView canPageViewSelectedAtPageIndex:(NSInteger)pageIndex;
@end

typedef NS_ENUM(NSInteger, TPUIBannerDirection) {
    TPUIBannerDirectionVertical, // 垂直方向
    TPUIBannerDirectionHorizontal // 水平方向
};

/// banner 视图
@interface TPUIBannerView : UIView
/// 滚动视图
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
/// 页面总数
@property (nonatomic, assign, readonly) NSInteger numberOfPages;
/// 预加载的分页数量 (默认为O)
@property (nonatomic, assign) NSUInteger preparedPageCount;
/// 循环滚动模式 (默认NO)
@property (nonatomic, assign) BOOL isCarousel;
/// 自动滚动时间间隔
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
/// 代理
@property (nonatomic, weak) id <TPUIBannerViewDelegate> delegate;
// 滑动方向, 默认水平方向
@property (nonatomic, assign) TPUIBannerDirection scrollDirection;
/**
 重新加载数据, 默认显示第0个分页
 */
- (void)reloadData;

/**
 重新加载数据，并显示当前页面
 @param index 当前页面下标
 */
- (void)reloadDataWithCurrentPageIndex:(NSInteger)index;

/**
 开启定时器
 @param timeInterval 定时滚动的时间间隔
 */
- (void)startTimerWithTimeInterval:(NSTimeInterval)timeInterval;

/**
 停止定时器
 */
- (void)stopTimer;

/**
 设置当前显示的分页

 @param index 分页下标
 @param animate 是否展示分页切换的动画
 */
- (void)setCurrentPageIndex:(NSInteger)index animate:(BOOL)animate;

/**
 @return 当前展示的分页下标
 */
- (NSInteger)currentPageIndex;

/**
 分页的重用
 @param identifier 重用标识符
 @return 分页
 */
- (__kindof TPUIBannerPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;
@end


