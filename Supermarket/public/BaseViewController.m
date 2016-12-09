//
//  BaseViewController.m
//  MobileClassPhone
//
//  Created by cyx on 14/11/13.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
//    if(!iPhone6Plus)
    return UIInterfaceOrientationMaskPortrait;
//    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskLandscape;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [ThirdStatisticsHelper beginPage:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [ThirdStatisticsHelper endPage:NSStringFromClass([self class])];
}

@end
