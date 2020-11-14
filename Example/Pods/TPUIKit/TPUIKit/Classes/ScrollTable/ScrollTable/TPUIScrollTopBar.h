//
//  TPUIScrollTopBar.h
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUITabbar.h"

NS_ASSUME_NONNULL_BEGIN

extern const CGFloat kTPUIScrollTopBarHeight;

/// 嵌套滚动视图 头部tabbar
@interface TPUIScrollTopBar : TPUITabbar
+ (instancetype)tabbar;
@end

NS_ASSUME_NONNULL_END
