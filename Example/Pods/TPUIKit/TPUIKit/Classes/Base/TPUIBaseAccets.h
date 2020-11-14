//
//  TPUIKitDefine.h
//  TPUIKit
//
//  Created by Topredator on 2019/2/22.
//

#import <Foundation/Foundation.h>

@interface TPUIBaseAccets : NSObject
/// 获取图片
+ (UIImage *)imageName:(NSString *)imageName;
/// PingFangSC-Medium 字体
+ (UIFont *)PFMediumFont:(CGFloat)fontSize;
/// PingFangSC-Regular 字体
+ (UIFont *)PFRegularFont:(CGFloat)fontSize;
/// PingFangSC-Semibold 字体
+ (UIFont *)PFSemiboldFont:(CGFloat)fontSize;
@end
