//
//  NSObject+LKDBHelper_DLExtension.m
//  MobileClassPhone
//
//  Created by Bryce on 14/12/8.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "BaseModel+LKDBHelper_DLExtension.h"
#import <LKDBHelper/LKDBHelper.h>

@implementation NSObject (LKDBHelper_DLExtension)

+ (NSArray *)searchAll
{
    return [self.class searchWithWhere:nil orderBy:nil offset:0 count:0];
}

+ (void)insertAll:(NSArray *)models
{
    Class clazz = [self class];
    LKDBHelper *globalHelper = [clazz getUsingLKDBHelper];

    [globalHelper executeDB:^(FMDatabase *db) {
         [db beginTransaction];

         BOOL result = NO;
         for (id item in models) {
             result = [globalHelper insertToDB:item];
             if (result == NO) {
                 break;
             }
         }

         if (result) {
             [db commit];
         } else {
             [db rollback];
         }
     }];
}

+ (void)clearAndInsertAll:(NSArray *)models
{
    Class clazz = [self class];
    [clazz clearAndInsertAll:models where:nil];
}

+ (void)clearAndInsertAll:(NSArray *)models where:(NSString *)where
{
    Class clazz = [self class];
    
    LKDBHelper *globalHelper = [clazz getUsingLKDBHelper];
    NSString *delCmd = [NSString stringWithFormat:@"DELETE FROM %@", [clazz getTableName]];
    if (where) {
        delCmd = [[delCmd stringByAppendingString:@" WHERE "] stringByAppendingString:where];
    }
    
    if ([globalHelper getTableCreatedWithTableName:[clazz getTableName]]) {
        [globalHelper executeSQL:delCmd arguments:nil];
    }

    [globalHelper executeDB:^(FMDatabase *db) {
        [db beginTransaction];
        
        BOOL result = NO;
        for (id item in models) {
            result = [globalHelper insertToDB:item];
            if (result == NO) {
                break;
            }
        }
        
        if (result) {
            [db commit];
        } else {
            [db rollback];
        }
    }];
}

@end
