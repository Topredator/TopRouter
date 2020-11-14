//
//  TPUIAlertMaker.h
//  TPUIKit
//
//  Created by Topredator on 2020/8/20.
//

#import <Foundation/Foundation.h>

typedef void(^TPUIOptionBlock)(void);
@interface TPUIAlertOption : NSObject
@property (nonatomic, copy) NSString *title;
/// 回调操作
@property (nonatomic, copy) TPUIOptionBlock block;
/// 设置字体颜色
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIAlertActionStyle actionStyle;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)optionWithTitle:(NSString *)title block:(TPUIOptionBlock)block;
+ (instancetype)optionWithTitle:(NSString *)title block:(TPUIOptionBlock)block actionStyle:(UIAlertActionStyle)actionStyle;

+ (instancetype)optionWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
@end
/// 只有title没有回调
NS_INLINE TPUIAlertOption *TPUIAlertTitleOption(NSString *title) {
    return [TPUIAlertOption optionWithTitle:title block:nil];
}
/// 带有回调
NS_INLINE TPUIAlertOption *TPUIAlertBlockOption(NSString *title, TPUIOptionBlock block) {
    return [TPUIAlertOption optionWithTitle:title block:block];
}
NS_INLINE TPUIAlertOption *TPUIAlertColorOption(NSString *title, TPUIOptionBlock block, UIColor *color) {
    TPUIAlertOption *option = [TPUIAlertOption optionWithTitle:title block:block];
    option.textColor = color ?: nil;
    return option;
}
/// target action
NS_INLINE TPUIAlertOption *TPUIAlertActionOption(NSString *title, id target, SEL selector) {
    return [TPUIAlertOption optionWithTitle:title target:target selector:selector];
}
NS_INLINE TPUIAlertOption *TPUIAlertColorAction(NSString *title, id target, SEL selector, UIColor *color) {
    TPUIAlertOption *option = [TPUIAlertOption optionWithTitle:title target:target selector:selector];
    option.textColor = color ?: nil;
    return option;
}


/// 用于构建alertController，包含alertController的配置项
@interface TPUIAlertMaker : NSObject
@property (nonatomic, copy) NSString *alertTitle;
@property (nonatomic, copy) NSString *alertMessage;
@property (nonatomic, assign) UIAlertControllerStyle alertStyle;
/// 储存所有的回调
@property (nonatomic, strong) NSMutableArray *options;
/*
 基本信息
 */
- (TPUIAlertMaker *(^)(NSString *))title;
- (TPUIAlertMaker *(^)(NSString *))message;
- (TPUIAlertMaker *(^)(UIAlertControllerStyle))style;
/*
 添加操作
 */
- (TPUIAlertMaker *(^)(TPUIAlertOption *))addOption;
/// 取消按钮
- (TPUIAlertMaker *(^)(NSString *))cancleOption;
@end


