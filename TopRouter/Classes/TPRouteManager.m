//
//  TPRouteManager.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "TPRouteManager.h"
#import "TPRouteMatcher.h"
#import "TPRouteRequest.h"

@interface TPRouteManager ()
/// 存储 <key : matcher>
@property (nonatomic, strong) NSMutableDictionary <NSString *, TPRouteMatcher *> *routeMatcheDic;
@end

static TPRouteManager *manager = nil;
@implementation TPRouteManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [TPRouteManager new];
    });
    return manager;
}
- (void)addRouteUrl:(NSString *)routeUrl handle:(TPRouteHandleBlock)handle {
    if (!routeUrl.length) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"请注册合法路由!" userInfo:nil];
    }
    TPRouteMatcher *matcher = self.routeMatcheDic[routeUrl];
    if (matcher) {
        NSLog(@"%@ ---- 已注册,请更换路由地址", routeUrl);
        return;
    }
    self.routeMatcheDic[routeUrl] = [TPRouteMatcher matcherWithExpression:routeUrl handleBlock:handle];
}

- (void)useRouteUrl:(NSString *)routeUrl completion:(__nullable TPRouteHandleCallBack)completion {
    [self useRouteUrl:routeUrl parameters:nil completion:completion];
}

- (void)useRouteUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters completion:(__nullable TPRouteHandleCallBack)completion {
    if (!routeUrl.length) {
        if (completion) completion(nil, TPRoutingStateBusinessError, @"请输入合法的路由地址");
        return;
    }
    for (NSString *route in self.routeMatcheDic.allKeys) {
        TPRouteMatcher *matcher = self.routeMatcheDic[route];
        TPRouteRequest *request = [matcher createRequestWithPattern:routeUrl originalParams:parameters];
        if (request) {
            if (completion) {
                completion(matcher.handleBlock(request.allParams), TPRoutingStateSuccess, @"处理成功");
            } else {
                matcher.handleBlock(request.allParams);
            }
            return;
        }
    }
    if (completion) {
        completion(nil, TPRoutingStateSystemError, @"未注册此路由 或 路径与注册时正则不匹配");
    }
    
}

#pragma mark ------------------------  lazy method ---------------------------
- (NSMutableDictionary <NSString *,TPRouteMatcher *> *)routeMatcheDic {
    if (!_routeMatcheDic) {
        _routeMatcheDic = @{}.mutableCopy;
    }
    return _routeMatcheDic;
}

@end
