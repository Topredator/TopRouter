//
//  TPUIBlankAccets.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "TPUIBlankAccets.h"

@implementation TPUIBlankAccets
+ (UIImage *)imageName:(NSString *)imageName {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"/TPUIKitBlank.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
}
@end
