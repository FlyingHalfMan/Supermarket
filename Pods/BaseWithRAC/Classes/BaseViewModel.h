//
//  BaseViewModel.h
//  MobileClassPhone
//
//  Created by Bryce on 14/12/18.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "RVMViewModel.h"

@class RACSubject;
@class RACDisposable;

//! 视图模型基类，定义公共的属性、方法
@interface BaseViewModel : RVMViewModel

@property (nonatomic, assign, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly) NSInteger currentPageStatus;

//! 内容更新信号
@property (nonatomic, readonly) RACSubject *updatedContentSignal;
//! 错误信号
@property (nonatomic, readonly) RACSubject *errorSignal;
@property (nonatomic, readonly, getter = getDisposeArray) NSArray *disposeArray;

//! 默认为YES，ViewModel在dealloc时自动调用dispose。设为NO，则手动调用销毁方法
@property (nonatomic, assign) BOOL autoDispose;
//! 添加销毁信号
- (void)addDisposeSignal:(RACDisposable *)signal;
//! 清空销毁信号列表
- (void)clearDisposeSignals;
//! 调用销毁信号
- (void)dispose;

@end
