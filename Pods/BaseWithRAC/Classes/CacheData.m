//
//  CacheData.m
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "CacheData.h"
#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import <DLUtls/CommUtls+File.h>



@implementation CacheData

static CacheData *sharedObj = nil;


+ (CacheData *)sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
            [sharedObj openSqlite];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            NSString *path =[documentDirectory stringByAppendingPathComponent:@"Cache.db"];
            [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:path error:NULL];
        }
    }
    return sharedObj;
}

- (FMDatabase *)getDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    FMDatabase *tempfmDatabase =[FMDatabase databaseWithPath:[documentDirectory stringByAppendingPathComponent:@"Cache.db"]];
    return tempfmDatabase;
}



/**
 *	@brief	打开数据库
 */
- (void)openSqlite
{
    _fmDatabase = [self getDB];
    if ( [_fmDatabase open] )
    {
        [_fmDatabase setShouldCacheStatements:YES];
        [_fmDatabase beginTransaction];
        [_fmDatabase executeUpdate:@"CREATE TABLE IF NOT EXISTS MOBILE_CACHE (_id INTEGER primary key autoincrement,event TEXT,time varchar(50))"];
        [_fmDatabase commit];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *cachesDbDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDbDirectory stringByAppendingPathComponent:@"Cache.db"];
    [CommUtls addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
    
}


- (void)dealloc
{
    [_fmDatabase close];
}

@end
