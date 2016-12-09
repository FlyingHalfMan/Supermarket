//
//  LMUPersonalTableViewController.h
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMUPersonalViewModel.h"
#import "LMUOrderlCategoryView.h"
#import "UserService.h"
@interface LMUPersonalTableViewController : UITableViewController
@property(nonatomic,strong)LMUPersonalViewModel* personalViewModel;
@property(nonatomic,strong)LMUOrderlCategoryView* OrderCategoryView;
@property(nonatomic,strong)UserService* service;

@end
