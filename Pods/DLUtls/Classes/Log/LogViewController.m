//
//  ViewController.m
//  Log
//
//  Created by song on 15/4/21.
//  Copyright (c) 2015年 songshoubing. All rights reserved.
//

#import "LogViewController.h"
#import "DLLog.h"
#import "DLiConsole.h"

#define LOG        @"LOG"
#define GLOBAL_LOG @"GLOBAL_LOG"
#define ERROR_LOG  @"ERROR_LOG"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSwitch];
    [self initTimeLabel];
}

- (void)initSwitch
{
    NSArray *title = @[@"日志", @"全局日志"];
    for (int i = 0; i < title.count; i++) {
        UILabel *label = [self createLabel];
        label.text = title[i];
        [self.view addSubview:label];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100 + 40 * i];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:40];
        NSLayoutConstraint *heighConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100];
        [self.view addConstraint:topConstraint];
        [self.view addConstraint:leftConstraint];
        [self.view addConstraint:heighConstraint];
        [self.view addConstraint:widthConstraint];
        
        UISwitch *logSwithc = [[UISwitch alloc]init];
        logSwithc.translatesAutoresizingMaskIntoConstraints = NO;
        if (i == 0) {
            logSwithc.on = [self logModel];
        }
        else if (i == 1) {
            if (![self logModel]) {
                logSwithc.on = NO;
                logSwithc.enabled = NO;
            }
            else {
                logSwithc.on =  [self globalLogModel];
            }
        }
        else {
            if (![self logModel]) {
                logSwithc.on = NO;
                logSwithc.enabled = NO;
            }
            else {
                logSwithc.on = [self errorLogModel];
            }
        }
        logSwithc.tag = i;
        [logSwithc addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:logSwithc];
        //view1.attr1 = view2.attr2 * multiplier + constant
        topConstraint = [NSLayoutConstraint constraintWithItem:logSwithc attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:100 + 40 * i];
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:logSwithc attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-40];
        widthConstraint = [NSLayoutConstraint constraintWithItem:logSwithc attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:60];
        [self.view addConstraint:topConstraint];
        [self.view addConstraint:rightConstraint];
        [self.view addConstraint:widthConstraint];
    }
}

- (void)changeSwitch:(UISwitch *)aSwitch
{
    if (aSwitch.tag == 0) {
        if (aSwitch.on) {
            // 日志开关 打开时，其他开关都 可用
            for (UISwitch *logSwitch in self.view.subviews) {
                if ([logSwitch isKindOfClass:[UISwitch class]] && logSwitch != aSwitch) {
                    logSwitch.enabled = YES;
                }
            }
        }
        else {
            // 日志开关 关闭时，其他开关都 禁用+并关闭
            for (UISwitch *logSwitch in self.view.subviews) {
                if ([logSwitch isKindOfClass:[UISwitch class]] && logSwitch != aSwitch) {
                    logSwitch.on = NO;
                    logSwitch.enabled = NO;
                    self.globalLogModel = NO;
                }
            }
        }
        [self setLogModel:aSwitch.on];
    }
    else if (aSwitch.tag == 1){
        [self setGlobalLogModel:aSwitch.on];
    }
    else{
        [self setErrorLogModel:aSwitch.on];
    }
}

#pragma mark - 日志
- (BOOL)logModel
{
    return [DLLog sharedInstance].isUseLog;
}

- (void)setLogModel:(BOOL)model
{
    [DLLog sharedInstance].isUseLog = model;
    [DLLogUploadHelper sharedInstance].openLog = (![DLLog sharedInstance].isUseLog && ![DLLog sharedInstance].isGlobalLog? NO : YES);
}

#pragma mark - 全局日志
- (BOOL)globalLogModel
{
    return [DLLog sharedInstance].isGlobalLog;
}

- (void)setGlobalLogModel:(BOOL)model
{
    [DLLog sharedInstance].isGlobalLog = model;
    [DLLogUploadHelper sharedInstance].openLog = (![DLLog sharedInstance].isUseLog && ![DLLog sharedInstance].isGlobalLog? NO : YES);
}

#pragma mark - 错误日志
- (BOOL)errorLogModel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:ERROR_LOG];
}

- (void)setErrorLogModel:(BOOL)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:model forKey:ERROR_LOG];
    [defaults synchronize];
}

#pragma mark - 显示时间
- (void)initTimeLabel
{
    UILabel *timeLabel = [self createLabel];
    NSDate *date = [NSDate date];
    timeLabel.text = [self stringFromDate:date];
    [self.view addSubview:timeLabel];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:220];
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:40];
    NSLayoutConstraint *heighConstraint = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:30];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:-40];
    [self.view addConstraint:topConstraint];
    [self.view addConstraint:leftConstraint];
    [self.view addConstraint:heighConstraint];
    [self.view addConstraint:rightConstraint];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (UILabel *)createLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
