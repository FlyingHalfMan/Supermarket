//
//  LoadDataService.h
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSubject;

#define BuildCacheKey(suffix) [NSString stringWithFormat:@"%@_CACHE_%@", self.class, suffix];

typedef NS_ENUM (NSInteger, CacheInfo)
{
    NoCache = 0, //没缓存
    ValidCache = 1, //有缓存
    InValidCache = 2 //缓存过期
};



@protocol LoadDataServiceDelegate <NSObject>

- (RACSignal *)loadNetData:(int)type parameters:(id)params,...;

- (RACSignal *)loadLocalData:(int)type parameters:(id)params,...;

- (CacheInfo)getCacheInfo:(int)type parameters:(id)params,...;

@end

@interface LoadDataService : NSObject<LoadDataServiceDelegate>

- (RACSignal *)loadData:(int)type parameters:(id)params,...;

- (RACSignal *)loadNetData:(int)type parameters:(id)params,...;

- (RACSignal *)loadLocalData:(int)type parameters:(id)params,...;

- (CacheInfo)getCacheInfo:(int)type parameters:(id)params,...;

@end
