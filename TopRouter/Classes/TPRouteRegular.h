//
//  TPRouteRegular.h
//  TopRouter
//
//  Created by Topredator on 2020/11/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TPRouteRegularResult : NSObject <NSCopying>
/// 是否匹配
@property (nonatomic, assign, getter=isMatch) BOOL match;
/// 参数属性
@property (nonatomic, copy) NSDictionary *paramProperties;
@end


/// 路由正则对象
@interface TPRouteRegular : NSRegularExpression
/// url改造后的 路由模式
@property (nonatomic, copy, readonly) NSString *transformPattern;
/// 通过url，初始化成正则表达式对象
+ (instancetype)regularWithPattern:(NSString *)pattern;

/// 通过url 产生一个response，检查是否匹配，并且将url路径中的关键字参数对应的值放入response对象中
- (TPRouteRegularResult *)responseForString:(NSString *)string;

/// 通过正则表达式匹配字符串，得到结果
/// @param expression 正则表达式
/// @param originalStr 需要匹配多大的字符串
+ (NSArray *)matchStringWithExpression:(NSString *)expression originalStr:(NSString *)originalStr;
@end

NS_ASSUME_NONNULL_END
