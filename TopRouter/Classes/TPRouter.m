//
//  TPRouter.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "TPRouter.h"
#import "TPRouteManager.h"

@implementation TPRouter
+ (void)registeRouteUrl:(NSString *)routeUrl handle:(TPRouteHandleBlock)handle {
    [[TPRouteManager manager] addRouteUrl:routeUrl handle:handle];
}

+ (void)routeUrl:(NSString *)routeUrl {
    [TPRouteManager.manager useRouteUrl:routeUrl completion:nil];
}

+ (void)routeUrl:(NSString *)routeUrl completion:(_Nullable TPRouteHandleCallBack)completion {
    [self routeUrl:routeUrl parameters:nil completion:completion];
}
+ (void)routeUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters {
    [TPRouteManager.manager useRouteUrl:routeUrl parameters:parameters completion:nil];
}
+ (void)routeUrl:(NSString *)routeUrl parameters:(NSDictionary <NSString *, id> * _Nullable )parameters completion:(_Nullable TPRouteHandleCallBack)completion {
    [[TPRouteManager manager] useRouteUrl:routeUrl parameters:parameters completion:completion];
}
@end
