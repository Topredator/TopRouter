//
//  TPRouteManager.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>
#import "TPRouteResultState.h"

NS_ASSUME_NONNULL_BEGIN

/// 路由 控制器 （负责管理路由表）
@interface TPRouteManager : NSObject
/// 单例初始化
+ (instancetype)manager;
/// 添加路由
- (void)addRouteUrl:(NSString *)routeUrl handle:(TPRouteHandleBlock)handle;

/// 路由调用
/// @param routeUrl 路由地址
/// @param completion 处理回调
- (void)useRouteUrl:(NSString *)routeUrl completion:(__nullable TPRouteHandleCallBack)completion;

/// 路由调用
/// @param routeUrl 路由地址
/// @param parameters 参数
/// @param completion 处理回调
- (void)useRouteUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters completion:(__nullable TPRouteHandleCallBack)completion;
@end

NS_ASSUME_NONNULL_END
