//
//  TPUISubVCScrollProtocol.h
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import <Foundation/Foundation.h>


/// 子视图控制器滑动协议
@protocol TPUISubVCScrollProtocol <NSObject>
@required
/// 通知父类的通知key
@property (nonatomic, copy) NSString *notifyParentKey;
/// 滑动的能力
@property (nonatomic, assign, getter=isCanScroll) BOOL canScroll;
/// 父类容器偏移量
@property (nonatomic, assign) CGFloat superOfferY;
@end



/// 集成此协议需要 实现如下:
/*
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     if (!self.isCanScroll) {
         scrollView.contentOffset = CGPointZero;
     }
     if (scrollView.contentOffset.y <= 0) {
         if (self.superOfferY == 0) {
             self.canScroll = YES;
         } else {
             self.canScroll = NO;
             scrollView.contentOffset = CGPointZero;
             [[NSNotificationCenter defaultCenter] postNotificationName:self.notifyParentKey object:nil];//到顶通知父视图改变状态
         }
     }
 }
 */

