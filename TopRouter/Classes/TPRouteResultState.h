//
//  TPRouteResultState.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#ifndef TPRouteResultState_h
#define TPRouteResultState_h

typedef NS_ENUM(NSInteger, TPRoutingState) {
    TPRoutingStateBusinessError = -1, // 业务错误
    TPRoutingStateSystemError = 0, // 系统错误，未发现注册
    TPRoutingStateSuccess // 成功
};
/// 路由处理回调
typedef void(^TPRouteHandleCallBack)(id result, TPRoutingState state, NSString *message);
/// 路由异步处理
typedef id (^TPRouteHandleBlock)(NSDictionary <NSString *, id> *parameters);


#endif /* TPRouteResultState_h */
