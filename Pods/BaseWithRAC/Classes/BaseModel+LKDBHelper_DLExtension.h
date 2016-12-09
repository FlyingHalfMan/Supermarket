//
//  NSObject+LKDBHelper_DLExtension.h
//  MobileClassPhone
//
//  Created by Bryce on 14/12/8.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BaseModel (LKDBHelper_DLExtension)

+ (NSArray *)searchAll;
// !插入Model数组，执行replace
+ (void)insertAll:(NSArray *)models;
+ (void)clearAndInsertAll:(NSArray *)models;
+ (void)clearAndInsertAll:(NSArray *)models where:(NSString *)where;

@end
