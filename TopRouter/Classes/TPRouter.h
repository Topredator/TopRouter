//
//  TPRouter.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>
#import "TPRouteResultState.h"

NS_ASSUME_NONNULL_BEGIN

/// 路由接口类
@interface TPRouter : NSObject

/// 注册路由
/// @param routeUrl 路由地址
/// @param handle 路由对应的处理
+ (void)registeRouteUrl:(NSString *)routeUrl handle:(TPRouteHandleBlock)handle;


/// 路由调用
/// @param routeUrl 路由地址
+ (void)routeUrl:(NSString *)routeUrl;
/// 路由调用
/// @param routeUrl 路由地址
/// @param completion 处理回调
+ (void)routeUrl:(NSString *)routeUrl completion:(_Nullable TPRouteHandleCallBack)completion;

+ (void)routeUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters;
/// 路由调用
/// @param routeUrl 路由地址
/// @param parameters 参数
/// @param completion 处理回调
+ (void)routeUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters completion:(_Nullable TPRouteHandleCallBack)completion;
@end

NS_ASSUME_NONNULL_END
