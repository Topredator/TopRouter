//
//  TPUIAlertMaker.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import "TPUIAlertMaker.h"
@implementation TPUIAlertOption
- (instancetype)init {
    self = [super init];
    if (self) {
        self.actionStyle = UIAlertActionStyleDefault;
    }
    return self;
}
+ (instancetype)optionWithTitle:(NSString *)title block:(TPUIOptionBlock)block {
    return [self optionWithTitle:title block:block actionStyle:UIAlertActionStyleDefault];
}
+ (instancetype)optionWithTitle:(NSString *)title block:(TPUIOptionBlock)block actionStyle:(UIAlertActionStyle)actionStyle {
    TPUIAlertOption *option = [TPUIAlertOption new];
    option.title = title;
    option.block = block;
    option.actionStyle = actionStyle;
    return option;
}
+ (instancetype)optionWithTitle:(NSString *)title target:(id)target selector:(SEL)selector {
    TPUIAlertOption *option = [TPUIAlertOption new];
    option.title = title;
    option.target = target;
    option.selector = selector;
    option.actionStyle = UIAlertActionStyleDefault;
    return option;
}
@end

@implementation TPUIAlertMaker
- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}
// 默认配置
- (void)defaultConfig {
    self.alertStyle = UIAlertControllerStyleAlert;
    self.options = @[].mutableCopy;
}
- (TPUIAlertMaker *(^)(NSString *))title {
    return ^ TPUIAlertMaker *(NSString *str) {
        self.alertTitle = str;
        return self;
    };
}
- (TPUIAlertMaker *(^)(NSString *))message {
    return ^ TPUIAlertMaker *(NSString *str) {
        self.alertMessage = str;
        return self;
    };
}
- (TPUIAlertMaker *(^)(UIAlertControllerStyle))style {
    return ^ TPUIAlertMaker *(UIAlertControllerStyle alertStyle) {
        self.alertStyle = alertStyle;
        return self;
    };
}
- (TPUIAlertMaker *(^)(TPUIAlertOption *))addOption {
    return ^ TPUIAlertMaker *(TPUIAlertOption *option) {
        if (option) {
            [self.options addObject:option];
        }
        return self;
    };
}
- (TPUIAlertMaker *(^)(NSString *))cancleOption {
    return ^ TPUIAlertMaker *(NSString *str) {
        if (str.length) {
            [self.options addObject:[TPUIAlertOption optionWithTitle:str block:nil actionStyle:UIAlertActionStyleCancel]];
        }
        return self;
    };
}
@end
