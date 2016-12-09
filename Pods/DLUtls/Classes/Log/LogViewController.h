//
//  ViewController.h
//  Log
//
//  Created by song on 15/4/21.
//  Copyright (c) 2015年 songshoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController

//日志
- (BOOL)logModel;

//全局日志
- (BOOL)globalLogModel;

//错误日志
- (BOOL)errorLogModel;

@end

