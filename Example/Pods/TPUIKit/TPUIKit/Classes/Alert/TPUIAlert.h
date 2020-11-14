//
//  TPUIAlert.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <Foundation/Foundation.h>
#import "TPUIAlertMaker.h"

/// 自定义alertController
@interface TPUIAlert : NSObject
@property (nonatomic, strong) TPUIAlertMaker *alertMark;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)alertShow:(void (^)(TPUIAlertMaker *make))maker;
/**
 具有回调的初始化
 */
+ (instancetype)alertShow:(void (^)(TPUIAlertMaker *make))maker completion:(void(^)(void))completion;

+ (instancetype)alertSheetShow:(void (^)(TPUIAlertMaker *make))maker;
+ (instancetype)alertSheetShow:(void (^)(TPUIAlertMaker *make))maker completion:(void (^)(void))completion;
@end


