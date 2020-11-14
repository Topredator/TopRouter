//
//  TPSecondVC.m
//  TopRouter_Example
//
//  Created by Topredator on 2020/11/14.
//  Copyright © 2020 Topredator. All rights reserved.
//

#import "TPSecondVC.h"
#import <TopRouter/TPRouter.h>
#import <TPUIKit/TPUINavigator.h>
@interface TPSecondVC ()

@end

@implementation TPSecondVC
+ (void)load {
    [TPRouter registeRouteUrl:@"gotoSecond" handle:^id(NSDictionary<NSString *,id> *parameters) {
        TPSecondVC *vc = [TPSecondVC new];
        vc.title = parameters[@"title"];
        [TPUINavigator pushViewController:vc animated:YES];
        return nil;
    }];
    [TPRouter registeRouteUrl:@"https://gotoSecond/:title" handle:^id(NSDictionary<NSString *,id> *parameters) {
        TPSecondVC *vc = [TPSecondVC new];
        vc.title = parameters[@"title"];
        [TPUINavigator pushViewController:vc animated:YES];
        return nil;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
}

@end
