//
//  TPRouteRequest.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 路由请求 模型 (Url分析： scheme://host:port/path?query#fragment)
@interface TPRouteRequest : NSObject
/// 外部调用的url
@property (nonatomic, copy, readonly) NSString *urlString;
/// 路由携带的参数
@property (nonatomic, copy, readonly) NSDictionary *routeParams;
/// 查询参数
@property (nonatomic, copy, readonly) NSDictionary *queryParams;
/// 原始参数
@property (nonatomic, copy, readonly) NSDictionary *originalParams;
/// 所有参数
@property (nonatomic, copy, readonly) NSDictionary *allParams;
- (instancetype)init NS_UNAVAILABLE;

/// 初始化
- (instancetype)initWithUrl:(NSString *)url routeParams:(NSDictionary *)routeParams queryParams:(NSDictionary *)queryParams originalParams:(NSDictionary <NSString *, id>*)originalParams;
- (id)objectForKeyedSubcript:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
