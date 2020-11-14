//
//  TPUIToastAccets.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIToastAccets.h"

@implementation TPUIToastAccets
+ (UIImage *)imageName:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/TPUIKitToast.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}
@end
