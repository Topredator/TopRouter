//
//  TPRouteRegular.m
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import "TPRouteRegular.h"

@implementation TPRouteRegularResult
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@  %p> - match: %@, params: %@", NSStringFromClass([self class]), self, self.match ? @"YES" : @"NO", self.paramProperties ?: @{}];
}
- (id)copyWithZone:(NSZone *)zone {
    TPRouteRegularResult *serialization = [[[self class] alloc] init];
    serialization.match = self.match;
    serialization.paramProperties = self.paramProperties;
    return serialization;
}
@end

/// 匹配 :xxxx(xx)、:xxx
static NSString *const kTPRouteParamPattern = @":[a-z0-9A-Z-_][^/]+";
/// 匹配 :xxxx
static NSString *const kTPRouteParamNamePattern = @":[a-z0-9A-Z-_]+";
/// 匹配 (xxx)
static NSString *const kTPRouteParamMatchPattern = @"([^/]+)";


@interface TPRouteRegular ()
/// 存放路由中附带参数名称
@property (nonatomic, copy) NSArray <NSString *> *routeParamNames;
@property (nonatomic, copy) NSString *transformPattern;
@end

@implementation TPRouteRegular
+ (instancetype)regularWithPattern:(NSString *)pattern {
    NSError *error;
    TPRouteRegular *regular = [[self alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    return regular;
}
- (instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError *__autoreleasing  _Nullable *)error {
    // 去掉 :xxx，在字符串前后添加 '^' '$'
    NSString *transformPattern = [TPRouteRegular transformFormPattern:pattern];
    self = [super initWithPattern:transformPattern options:options error:error];
    if (self) {
        self.transformPattern = transformPattern;
        // 获取所有参数
        self.routeParamNames = [[self class] routeParamNamesForPattern:pattern];
    }
    return self;
}
- (TPRouteRegularResult *)responseForString:(NSString *)string {
    NSArray <NSTextCheckingResult *> *array = [self matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
    TPRouteRegularResult *result = [TPRouteRegularResult new];
    if (!array.count) return result;
    // 匹配到了
    result.match = YES;
    // 参数对照 配对，存入字典
    NSMutableDictionary *mDic = @{}.mutableCopy;
    for (NSTextCheckingResult *res in array) {
        NSInteger k = 0;
        for (NSInteger i = 1; i < res.numberOfRanges; i++) {
            if ([res rangeAtIndex:i].length == 0) continue;
            if ([[string substringWithRange:[res rangeAtIndex:i]] containsString:@"://"]) continue;
            NSString *paramName = self.routeParamNames[k];
            NSString *paramValue = [string substringWithRange:[res rangeAtIndex:i]];
            mDic[paramName] = paramValue;
            k ++;
        }
    }
    result.paramProperties = mDic.copy;
    return result;
}
+ (NSArray *)matchStringWithExpression:(NSString *)expression originalStr:(NSString *)originalStr {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regularExpression matchesInString:originalStr options:NSMatchingReportProgress range:NSMakeRange(0, originalStr.length)];
    NSMutableArray *arr = @[].mutableCopy;
    for (NSTextCheckingResult *result in results) {
        NSString *resultString = [originalStr substringWithRange:result.range];
        [arr addObject:resultString];
    }
    return arr.copy;
}
#pragma mark ------------------------  private method  ---------------------------
+ (NSString *)transformFormPattern:(NSString *)pattern {
    NSString *transfromPattern = [pattern copy];
    // 获取 ':xxx()'部分
    NSArray <NSString *> *paramPatternStrings = [self paramPatternStringsFromPattern:pattern];
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:kTPRouteParamNamePattern options:NSRegularExpressionCaseInsensitive error:&error];
    /*
     * 实例：user/login/:account/:password([a-z0-9A-Z]+)
     *替换后：user/login/([^/]+)/([a-z0-9A-Z]+)
     */
    for (NSString *paramPatternString in paramPatternStrings) {
        NSString *replaceParamPatternString = [paramPatternString copy];
        NSTextCheckingResult *paramPattermResult = [expression matchesInString:paramPatternString options:NSMatchingReportProgress range:NSMakeRange(0, paramPatternString.length)].firstObject;
        if (paramPattermResult) {
            NSString *paramNameString = [paramPatternString substringWithRange:paramPattermResult.range];
            replaceParamPatternString = [replaceParamPatternString stringByReplacingOccurrencesOfString:paramNameString withString:@""];
        }
        // 替换之后 如果为空字符串，直接改为默认的正则
        if (replaceParamPatternString.length == 0) {
            replaceParamPatternString = kTPRouteParamMatchPattern;
        }
        transfromPattern = [transfromPattern stringByReplacingOccurrencesOfString:paramPatternString withString:replaceParamPatternString];
    }
    // 添加 正则的 ^$
    if (transfromPattern.length && !([transfromPattern characterAtIndex:0] == '/')) {
        transfromPattern = [@"^" stringByAppendingString:transfromPattern];
    }
    transfromPattern = [transfromPattern stringByAppendingString:@"$"];
    return transfromPattern;
}
+ (NSArray <NSString *> *)routeParamNamesForPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:kTPRouteParamNamePattern options:NSRegularExpressionCaseInsensitive error:&error];
    // 获取 ':xxx()'部分
    NSArray *paramPatternStrings = [self paramPatternStringsFromPattern:pattern];
    NSMutableArray *routeParamNames = @[].mutableCopy;
    for (NSString *patternString in paramPatternStrings) {
        NSTextCheckingResult *paramNamesResult = [expression matchesInString:patternString options:NSMatchingReportProgress range:NSMakeRange(0, patternString.length)].firstObject;
        if (paramNamesResult) {
            NSString *paramNameString = [patternString substringWithRange:paramNamesResult.range];
            // 去掉冒号:
            paramNameString = [paramNameString stringByReplacingOccurrencesOfString:@":" withString:@""];
            [routeParamNames addObject:paramNameString];
        }
    }
    return routeParamNames.copy;
}
+ (NSArray <NSString *> *)paramPatternStringsFromPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:kTPRouteParamPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray <NSTextCheckingResult *> *paramPatternResults = [expression matchesInString:pattern options:NSMatchingReportProgress range:NSMakeRange(0, pattern.length)];
    NSMutableArray *mArr = @[].mutableCopy;
    for (NSTextCheckingResult *result in paramPatternResults) {
        NSString *paramPatternString = [pattern substringWithRange:result.range];
        [mArr addObject:paramPatternString];
    }
    return mArr.copy;
}
@end
