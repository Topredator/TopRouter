//
//  TPUIKitDefine.m
//  TPUIKit
//
//  Created by Topredator on 2019/2/22.
//
#import "TPUIBaseAccets.h"

@implementation TPUIBaseAccets
+ (UIImage *)imageName:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/TPUIKitBase.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}
+ (UIFont *)PFMediumFont:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if ([[UIDevice currentDevice].systemVersion compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
        font = [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    }
    return font;
}
+ (UIFont *)PFRegularFont:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if ([[UIDevice currentDevice].systemVersion compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
        font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    }
    return font;
}
+ (UIFont *)PFSemiboldFont:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if ([[UIDevice currentDevice].systemVersion compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
        font = [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    }
    return font;
}
@end
