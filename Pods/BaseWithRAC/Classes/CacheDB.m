//
//  CacheDB.m
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "CacheDB.h"
#import "CacheData.h"

#import <DLUtls/CommUtls+Time.h>
#import <MD5Digest/NSString+MD5.h>
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
@implementation CacheDB


+ (void)addCache:(NSString *)key
{
    NSString *date = [CommUtls encodeTime:[NSDate date]];
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    BOOL isAdd = YES;
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MOBILE_CACHE WHERE event = ?",key];
    if(rs != nil)
    {
        if([rs next])
        {
            [rs close];
            isAdd =  NO;
        }
        if(isAdd)
            [db executeUpdate:@"INSERT INTO MOBILE_CACHE (time,event) VALUES (?,?)",date,key];
        else
            [db executeUpdate:@"UPDATE MOBILE_CACHE SET time = ? WHERE event = ?",date,key];
    }
}


+ (CacheStatus)cacheStatus:(NSString *)key
{
    CacheStatus status = NoCacheDB;
    NSInteger seconds = 75000;
    NSString *dateStr = [CommUtls encodeTime:[NSDate date]];
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MOBILE_CACHE WHERE event = ?",key];
    if ( rs != nil )
    {
        if([rs next])
        {
            NSString *recordDateStr = [rs stringForColumn:@"time"];
            NSDate *recordDate = [CommUtls dencodeTime:recordDateStr];
            NSDate *date = [CommUtls dencodeTime:dateStr];
            NSTimeInterval tseconds = [date timeIntervalSinceDate:recordDate];
            if(tseconds > seconds)
            {
                [rs close];
                status = InValidCacheDB;
            }
            else
            {
                [rs close];
                status = ValidCacheDB;
            }
        }
        
    }
    return status;
}


+ (CacheStatus)cacheStatus:(NSString *)key timeLong:(NSInteger)seconds
{
    CacheStatus status = NoCacheDB;
    if(seconds == 0)
        seconds = 75000;
    NSString *dateStr = [CommUtls encodeTime:[NSDate date]];
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MOBILE_CACHE WHERE event = ?",key];
    if ( rs != nil )
    {
        if([rs next])
        {
            NSString *recordDateStr = [rs stringForColumn:@"time"];
            NSDate *recordDate = [CommUtls dencodeTime:recordDateStr];
            NSDate *date = [CommUtls dencodeTime:dateStr];
            NSTimeInterval tseconds = [date timeIntervalSinceDate:recordDate];
            if(tseconds > seconds)
            {
                [rs close];
                status = InValidCacheDB;
            }
            else
            {
                [rs close];
                status = ValidCacheDB;
            }
        }
        
    }
    return status;
}


+ (CacheStatus)cacheStatusNoInvalid:(NSString *)key
{
    CacheStatus status = NoCacheDB;
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MOBILE_CACHE WHERE event = ?",key];
    if ( rs != nil )
    {
        if([rs next])
        {
            [rs close];
            status = ValidCacheDB;
        }
    }
    return status;
}


+ (void)deleteAllCache
{
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    [db executeUpdate:@"DELETE FROM MOBILE_CACHE"];
}

+ (void)deleteCache:(NSString *)key
{
    FMDatabase *db = [CacheData sharedInstance].fmDatabase;
    [db executeUpdate:@"DELETE FROM MOBILE_CACHE WHERE event = ?",key];
}

@end
