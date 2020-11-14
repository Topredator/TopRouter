//
//  UIBarButtonItem+TPUIButtonItem.m
//  TPUIKit
//
//  Created by Topredator on 2020/8/19.
//

#import "UIBarButtonItem+TPUIButtonItem.h"
#import "TPUIBaseAccets.h"
@implementation UIBarButtonItem (TPUIButtonItem)
+ (UIBarButtonItem *)tp_backItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[TPUIBaseAccets imageName:@"TP_common_blackBack"] forState:UIControlStateNormal];
    [btn setImage:[TPUIBaseAccets imageName:@"TP_common_blackBack"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 30, 30);
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = YES;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)tp_customBackItemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self tp_customBackItemWithImage:image highlightedImage:image target:target action:action];
}
+ (UIBarButtonItem *)tp_customBackItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = YES;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end
