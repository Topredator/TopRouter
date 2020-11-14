//
//  TPUIBaseTableViewCell.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 基类 单元格
@interface TPUIBaseTableViewCell : UITableViewCell
/// 布局子视图
- (void)setupSubviews;
/// 添加约束
- (void)makeConstraints;
@end

NS_ASSUME_NONNULL_END
