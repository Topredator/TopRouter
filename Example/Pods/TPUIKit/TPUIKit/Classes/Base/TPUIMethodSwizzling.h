//
//  TPUIMethodSwizzling.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import <Foundation/Foundation.h>

/**
 交换类的实例方法
 @param originClass 需要交换的类
 @param originSelector 交换前的实例方法
 @param swizzledSelector 交换后的实例方法
 */
void TPUIKitSwizzling(Class originClass, SEL originSelector, SEL swizzledSelector);
