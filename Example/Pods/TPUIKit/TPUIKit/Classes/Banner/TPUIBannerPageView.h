//
//  TPUIBannerPageView.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// banner 的单元格视图
@interface TPUIBannerPageView : UIView
/// 重用标识符
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;
/// 点击手势
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;

/**
 初始化
 @param reuseIdentifier 重用标识符
 @return 初始化的PageView
 */
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 当pageView准备被重用的时候会触发这个方法
 */
- (void)prepareForReuse;
@end

NS_ASSUME_NONNULL_END
