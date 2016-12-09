//
//  DLMacro.h
//  DL
//
//  Created by cyx on 14-9-16.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#ifndef Base_Macro_h
#define Base_Macro_h

#import <ReactiveCocoa/NSObject+RACPropertySubscribing.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/UIGestureRecognizer+RACSignalSupport.h>
#import <ReactiveViewModel/RVMViewModel.h>
#import <DLUtls/CommUtls.h>


#define NodeExist(node) (node != nil && ![node isEqual:[NSNull null]])

#ifdef DEBUG
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)

#else
#define CLog(format, ...)
#endif


#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0? YES : NO)
#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0? YES : NO)
#define IsIOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0? YES : NO)


#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)


#define  CustomErrorDomain  @"com.cdeledu.err"

typedef enum{
    DLDataFailed = -1000,
    DLNoNet,
}CustomErrorFailed;


#endif
