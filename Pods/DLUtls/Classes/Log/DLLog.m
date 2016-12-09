//
//  DLLog.m
//  Pods
//
//  Created by cyx on 15/4/21.
//
//

#import "DLLog.h"
#import <stdarg.h>
#import <string.h>
#import <TargetConditionals.h>
#import "DLInterfaceCrypto.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>
#import <DLUtls/CommUtls+File.h>

@interface DLLog ()

@property (atomic,strong) FMDatabase *database;
@property (atomic,strong) FMDatabaseQueue *databaseQueue;
@property (assign) NSInteger dataNumTotal;

@end

@implementation DLLog

static DLLog *sharedObj = nil;

+ (DLLog *)sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            sharedObj = [[self alloc] init];
            sharedObj.isUseLog = [defaults boolForKey:@"isUseLog"];
            sharedObj.isGlobalLog = [defaults boolForKey:@"isGlobalLog"];
        }
    }
    return sharedObj;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self getDbQueue];
        NSSetUncaughtExceptionHandler(&exceptionHandler);
        //清除老日志接口数据
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"iConsoleLog"];
    }
    return self;
}

+ (void)info:(NSString *)format, ...
{
    if([self sharedInstance].isUseLog)
    {
        va_list argList;
        va_start(argList, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
        message = [NSString stringWithFormat:@"CDEL%@",[DLInterfaceCrypto DL_DESEncrypt:message withKey:@"cdel0927"]];
        [[self sharedInstance] info:message args:argList];
        va_end(argList);
    }
}

//+ (void)error:(NSString *)format, ...
//{
//    if([self sharedInstance].isUseLog)
//    {
//        va_list argList;
//        va_start(argList, format);
//        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//        message = [NSString stringWithFormat:@"CDEL%@",[DLInterfaceCrypto DL_DESEncrypt:message withKey:@"cdel0927"]];
//        [[self sharedInstance] error:message args:argList];
//        va_end(argList);
//    }
//}

#pragma mark - 设置日志记录权限
+ (void)globalInfo:(NSString *)format, ...
{
    if( [self sharedInstance].isUseLog && [self sharedInstance].isGlobalLog)
    {
        va_list argList;
        va_start(argList, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
        message = [NSString stringWithFormat:@"CDEL%@",[DLInterfaceCrypto DL_DESEncrypt:message withKey:@"cdel0927"]];
        [[self sharedInstance] info:message args:argList];
        va_end(argList);
    }
}

//+ (void)globalErro:(NSString *)format, ...
//{
//    if( [self sharedInstance].isUseLog && [self sharedInstance].isGlobalLog)
//    {
//        va_list argList;
//        va_start(argList, format);
//        NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//        message = [NSString stringWithFormat:@"CDEL%@",[DLInterfaceCrypto DL_DESEncrypt:message withKey:@"cdel0927"]];
//        [[self sharedInstance] error:message args:argList];
//        va_end(argList);
//    }
//}

- (void)setIsUseLog:(BOOL)isUseLog
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isUseLog forKey:@"isUseLog" ];
    [defaults synchronize];
}

- (BOOL)isUseLog
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isUseLog"];
}

- (void)setIsGlobalLog:(BOOL)isGlobalLog
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:isGlobalLog forKey:@"isGlobalLog" ];
    [defaults synchronize];
}

- (BOOL)isGlobalLog
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"isGlobalLog"];
}

#pragma mark - 日志记录
- (void)info:(NSString *)format args:(va_list)argList
{
    [self log:[NSString stringWithFormat:@"INFO: %@\n%@\n",[self loggingTime],format] args:argList];
}

//- (void)warn:(NSString *)format args:(va_list)argList
//{
//    [self log:[NSString stringWithFormat:@"WARNING: %@-%@",[self loggingTime],format] args:argList];
//}
//
//- (void)error:(NSString *)format args:(va_list)argList
//{
//    [self log:[NSString stringWithFormat:@"ERROR: %@-%@",[self loggingTime],format] args:argList];
//}
//
//- (void)crash:(NSString *)format args:(va_list)argList
//{
//    [self log:[NSString stringWithFormat:@"CRASH: %@-%@",[self loggingTime],format] args:argList];
//}

static void exceptionHandler(NSException *exception)
{
//    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
//    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
//    NSString *name = [exception name];//异常类型
    static BOOL crash = YES;
    if (crash) {
        crash = NO;
        [[DLLog sharedInstance] log:[NSString stringWithFormat:@"CRASH: %@\n%@\n%@\n%@\n",[[DLLog sharedInstance] loggingTime], exception.name, exception.reason, exception.callStackSymbols] args:nil];
    }
}

- (NSString *)loggingTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)log:(NSString *)format args:(va_list)argList
{
    NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
#ifdef DEBUG
    NSLog(@"%@",message);
#endif
    if (message.length > 0) {
        if ([NSThread currentThread] == [NSThread mainThread]) {
            [self logOnMainThread:message];
        } else {
            [self performSelectorOnMainThread:@selector(logOnMainThread:) withObject:message waitUntilDone:NO];
        }
    }
}

#define Logging_Max_Num         1000
- (void)logOnMainThread:(NSString *)message
{
    if (self.database.open) {
        [self.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            if (self.dataNumTotal >= Logging_Max_Num) {
                NSString *sql = [NSString stringWithFormat:@"DELETE FROM DLLogging where _id not in (select _id from DLLogging order by _id desc limit %d)",Logging_Max_Num-100];
                [db executeUpdate:sql];
                self.dataNumTotal -= 100;
            }
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO DLLogging (message) VALUES ('%@')",message];
            [db executeUpdate:sql];
        }];
        self.dataNumTotal+=1;
    }
}

+ (NSArray *)fetchLoggingMsg
{
    NSMutableArray *array = [NSMutableArray new];
    if ([self sharedInstance].database.open) {
        [[self sharedInstance].databaseQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT * FROM DLLogging order by _id desc"];
            if (rs != nil) {
                while ([rs next]) {
                    [array addObject:[rs stringForColumn:@"message"]];
                }
                [rs close];
            }
        }];
    }
    return array.count?array:nil;
}

+ (void)clearLoggingMsg
{
    if ([self sharedInstance].database.open) {
        [[self sharedInstance].databaseQueue inTransaction:^(FMDatabase *db,BOOL *rollback){
            [db executeUpdate:@"DELETE FROM DLLogging"];
        }];
    }
}

#pragma mark - 数据库操作
- (void)getDbQueue
{
    FMDatabase *database = [FMDatabase databaseWithPath:[self getDBPath]];
    if ([database open]) {
        [database setShouldCacheStatements:YES];
        [database beginTransaction];
        [database executeUpdate:@"CREATE TABLE IF NOT EXISTS DLLogging (_id INTEGER primary key autoincrement,message text)"];
        [database commit];
    }
    self.database = database;
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:[self getDBPath]];
    [CommUtls addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[self getDBPath]]];
    [[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:[self getDBPath] error:NULL];
    
    if (self.database.open) {
        [self.databaseQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select count(*) from DLLogging"];
            if (rs != nil) {
                if ([rs next]) {
                    NSInteger count = [rs intForColumnIndex:0];
                    self.dataNumTotal = count;
                }
                [rs close];
            }
        }];
    }
}

- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDbDirectory = [paths objectAtIndex:0];
    NSString *path = [cachesDbDirectory stringByAppendingPathComponent:@"DLLog.db"];
    return path;
}

@end
