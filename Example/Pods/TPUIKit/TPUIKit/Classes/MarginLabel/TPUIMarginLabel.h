//
//  TPUIMarginLabel.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/22.
//

#import <UIKit/UIKit.h>

/// 能设置内边距的label
@interface TPUIMarginLabel : UILabel
/// 内边距
@property (nonatomic, assign) UIEdgeInsets textInsets;
+ (instancetype)marginLabel:(UIEdgeInsets)textInsets;
@end


