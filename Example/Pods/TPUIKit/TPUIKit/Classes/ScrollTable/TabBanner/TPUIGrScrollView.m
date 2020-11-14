//
//  TPUIGrScrollView.m
//  TPUIKit
//
//  Created by Topredator on 2020/10/31.
//

#import "TPUIGrScrollView.h"

@implementation TPUIGrScrollView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
