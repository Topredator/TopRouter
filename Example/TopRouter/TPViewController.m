//
//  TPViewController.m
//  TopRouter
//
//  Created by Topredator on 11/14/2020.
//  Copyright (c) 2020 Topredator. All rights reserved.
//

#import "TPViewController.h"
#import <Masonry/Masonry.h>
#import <TopRouter/TPRouter.h>
@interface TPViewController ()

@end

@implementation TPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"首页";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = UIColor.purpleColor;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn1 setTitle:@"跳转" forState:UIControlStateNormal];
    [btn1 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickAction1) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = UIColor.purpleColor;
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(btn.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
    }];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn2 setTitle:@"跳转" forState:UIControlStateNormal];
    [btn2 setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickAction2) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = UIColor.purpleColor;
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(btn1.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
    }];
}
- (void)clickAction {
    [TPRouter routeUrl:@"https://gotoSecond/Second"];
}
- (void)clickAction1 {
    [TPRouter routeUrl:@"gotoSecond?title=Second"];
    
}
- (void)clickAction2 {
    [TPRouter routeUrl:@"gotoSecond" parameters:@{@"title": @"Second"}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
