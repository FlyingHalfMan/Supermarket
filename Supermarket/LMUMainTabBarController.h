//
//  LMUMainTabBarController.h
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMUPersonalTableViewController.h"
#import "LMUCartTableViewController.h"
#import "LMUMapViewController.h"
#import "LMUHomeViewController.h"
@interface LMUMainTabBarController : UITabBarController
@property(nonatomic,strong)LMUPersonalTableViewController* personalVC;
@property(nonatomic,strong)LMUCartTableViewController* cartVC;
@property(nonatomic,strong)LMUMapViewController* mapVC;
@property(nonatomic,strong)LMUHomeViewController* homeVC;
@end
