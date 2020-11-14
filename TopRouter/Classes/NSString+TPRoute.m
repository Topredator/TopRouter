//
//  NSString+TPRoute.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "NSString+TPRoute.h"

@implementation NSString (TPRoute)
- (NSDictionary *)tp_routeParamsFromQueryString {
    if (!self.length) return @{};
    NSArray *params = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDic = @{}.mutableCopy;
    for (NSString *param in params) {
        NSArray *pairs = [param componentsSeparatedByString:@"="];
        if (pairs.count == 2) {
            NSString *key = [pairs[0] stringByRemovingPercentEncoding];
            NSString *value = [pairs[1] stringByRemovingPercentEncoding];
            if (key && value) paramsDic[key] = value;
        } else if (pairs.count == 1) {
            NSString *key = [[pairs firstObject] stringByRemovingPercentEncoding];
            paramsDic[key] = @"";
        }
    }
    return [paramsDic copy];
}
@end
