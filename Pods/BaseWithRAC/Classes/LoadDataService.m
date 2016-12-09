//
//  LoadDataService.m
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "LoadDataService.h"
#import <DLUtls/NetStatusHelper.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


@implementation LoadDataService

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

- (RACSignal *)loadData:(int)type parameters:(id)params,...
{
    if ([self getCacheInfo:type parameters:params] == NoCache || [self getCacheInfo:type parameters:params] == InValidCache) {
        if ([NetStatusHelper sharedInstance].netStatus != NoneNet)
            return [self loadNetData:type parameters:params];
        else if([NetStatusHelper sharedInstance].netStatus == NoneNet && [self getCacheInfo:type parameters:params] == InValidCache)
        return [self loadLocalData:type parameters:params];
        else if([NetStatusHelper sharedInstance].netStatus == NoneNet && [self getCacheInfo:type parameters:params] == NoCache)
        {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"is a error no net"                                                                      forKey:NSLocalizedDescriptionKey];
        NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:DLNoNet userInfo:userInfo];
        return [RACSignal error:aError];
        }
        
    } else if ([self getCacheInfo:type parameters:params] == ValidCache) {
        return [self loadLocalData:type parameters:params];
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"is a error no data"                                                                      forKey:NSLocalizedDescriptionKey];
    NSError *aError = [NSError errorWithDomain:CustomErrorDomain code:DLDataFailed userInfo:userInfo];
    return [RACSignal error:aError];
}

- (RACSignal *)loadNetData:(int)type parameters:(id)params,...
{
    return [RACSignal empty];
}

- (RACSignal *)loadLocalData:(int)type parameters:(id)params,...
{
    return [RACSignal empty];
}

- (CacheInfo)getCacheInfo:(int)type parameters:(id)params,...
{
    return NoCache;
}

@end
