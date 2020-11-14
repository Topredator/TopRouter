//
//  TPUIRefreshAccets.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIRefreshAccets.h"

@implementation TPUIRefreshAccets
+ (UIImage *)imageName:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/TPUIKitRefresh.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}
@end
