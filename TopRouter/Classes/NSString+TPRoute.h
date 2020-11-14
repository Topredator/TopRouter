//
//  NSString+TPRoute.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 路由字符串 处理
@interface NSString (TPRoute)

/// 查询字段 转为 键值对
- (NSDictionary *)tp_routeParamsFromQueryString;
@end

NS_ASSUME_NONNULL_END
