//
//  TPRouteMatcher.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>
#import "TPRouteResultState.h"


NS_ASSUME_NONNULL_BEGIN
@class TPRouteRequest;
/// 路由匹配器
@interface TPRouteMatcher : NSObject
/// 处理的闭包
@property (nonatomic, copy, readonly) TPRouteHandleBlock handleBlock;
/// 初始化  通过表达式、处理创建
/// @param expression 表达式
/// @param handleBlock 处理
+ (instancetype)matcherWithExpression:(NSString *)expression handleBlock:(TPRouteHandleBlock)handleBlock;
/// 通过传入的路由地址 获取路由请求对象
- (TPRouteRequest *)createRequestWithPattern:(NSString *)pattern originalParams:(NSDictionary * _Nullable)originalParams;
@end

NS_ASSUME_NONNULL_END
