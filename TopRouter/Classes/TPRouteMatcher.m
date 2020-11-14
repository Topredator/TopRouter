//
//  TPRouteMatcher.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "TPRouteMatcher.h"
#import "TPRouteRequest.h"
#import "TPRouteRegular.h"
#import "NSString+TPRoute.h"
@interface TPRouteMatcher ()
/// 正则对象
@property (nonatomic, strong) TPRouteRegular *routeRegular;
@end

@implementation TPRouteMatcher
+ (instancetype)matcherWithExpression:(NSString *)expression handleBlock:(TPRouteHandleBlock)handleBlock {
    return [[self alloc] initWithRouteExpression:expression handleBlock:handleBlock];
}
- (instancetype)initWithRouteExpression:(NSString *)routeExpression handleBlock:(TPRouteHandleBlock)handleBlock {
    if (!routeExpression.length) return nil;
    self = [super init];
    if (self) {
        _handleBlock = handleBlock;
        _routeRegular = [TPRouteRegular regularWithPattern:routeExpression];
    }
    return self;
}
- (TPRouteRequest *)createRequestWithPattern:(NSString *)pattern originalParams:(NSDictionary *)originalParams {
    if (!pattern.length) return nil;
    // 匹配url中的 scheme://path
    NSString *patternString;
    NSDictionary *queryParamsDic = nil;
    NSArray *patterns = [TPRouteRegular matchStringWithExpression:@"[^\?]+" originalStr:pattern];
    if (!patterns.count) return nil;
    if (patterns.count == 1) {
        patternString = pattern.copy;
    } else if (patterns.count > 1) {
        patternString = patterns.firstObject;
        NSString *queryString = [[patterns objectAtIndex:1] copy];
        queryParamsDic = [queryString tp_routeParamsFromQueryString];
    }
    TPRouteRegularResult *result = [self.routeRegular responseForString:patternString];
    // 没匹配上
    if (!result.isMatch) return nil;
    return [[TPRouteRequest alloc] initWithUrl:patternString routeParams:result.paramProperties queryParams:queryParamsDic originalParams:originalParams];
}
@end
