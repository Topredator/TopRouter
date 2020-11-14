//
//  TPRouteRequest.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "TPRouteRequest.h"

@interface TPRouteRequest ()
/// 外部调用的url
@property (nonatomic, copy) NSString *urlString;
/// 路由携带的参数
@property (nonatomic, copy) NSDictionary *routeParams;
/// 查询参数
@property (nonatomic, copy) NSDictionary *queryParams;
/// 原始参数
@property (nonatomic, copy) NSDictionary *originalParams;
/// 所有参数
@property (nonatomic, copy) NSDictionary *allParams;
@end

@implementation TPRouteRequest
- (instancetype)initWithUrl:(NSString *)url routeParams:(NSDictionary *)routeParams queryParams:(NSDictionary *)queryParams originalParams:(NSDictionary <NSString *, id>*)originalParams {
    if (!url) return nil;
    self = [super init];
    if (!self) return nil;
    self.urlString = url;
    self.routeParams = routeParams;
    self.queryParams = queryParams;
    self.originalParams = originalParams;
    self.allParams = [self fetchAllParams];
    return self;
}
- (NSDictionary *)fetchAllParams {
    NSMutableDictionary *mDic = @{}.mutableCopy;
    [mDic addEntriesFromDictionary:self.routeParams];
    [mDic addEntriesFromDictionary:self.queryParams];
    [mDic addEntriesFromDictionary:self.originalParams];
    return mDic.copy;
}
- (id)objectForKeyedSubcript:(NSString *)key {
    id value = [self.queryParams objectForKey:key];
    if (!value) {
        value = [self.originalParams objectForKey:key];
    }
    return value;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@  %p> - URL: %@", NSStringFromClass([self class]), self, self.urlString ?: @""];
}
#pragma mark ------------------------  Zone  ---------------------------
- (id)copyWithZone:(NSZone *)zone {
    return [[TPRouteRequest alloc] initWithUrl:self.urlString routeParams:self.routeParams queryParams:self.queryParams originalParams:self.originalParams];
}
@end
