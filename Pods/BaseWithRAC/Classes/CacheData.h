//
//  CacheData.h
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface CacheData : NSObject

+ (CacheData *)sharedInstance;
@property (nonatomic,readonly) FMDatabase *fmDatabase;

@end
