//
//  BaseViewModel.m
//  MobileClassPhone
//
//  Created by Bryce on 14/12/18.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "BaseViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BaseViewModel ()

@property (nonatomic, strong) NSMutableArray *racDisposes;

@end

@implementation BaseViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"%@ updatedContentSignal", self.class];
        _errorSignal = [[RACSubject subject] setNameWithFormat:@"%@ errorSignal", self.class];
        _racDisposes = [NSMutableArray array];
        _autoDispose = YES;
    }

    return self;
}

- (void)addDisposeSignal:(RACDisposable *)signal
{
    if (!signal) {
        return;
    }
    [self.racDisposes addObject:signal];
}

- (void)clearDisposeSignals
{
    [self.racDisposes removeAllObjects];
}

- (void)dispose
{
    for (RACDisposable *racdispose in self.racDisposes) {
        [racdispose dispose];
    }
    [self clearDisposeSignals];
    self.loading = NO;
}

- (NSArray *)getDisposeArray
{
    return _racDisposes;
}

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
    if (self.autoDispose && self.racDisposes.count > 0) {
        [self dispose];
    }
}

@end
