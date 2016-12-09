//
//  DLStaticDataBase.m
//  Pods
//
//  Created by cdeledu on 14-11-27.
//
//

#import "DLStaticDataBase.h"
#import "FMDatabase.h"
#import "CommUtls+DeviceInfo.h"

@interface DLStaticDataBase ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DLStaticDataBase

@synthesize db = _db;

static DLStaticDataBase *defaultDataBase= nil;

+ (DLStaticDataBase *)defaultStaticDB {
  @synchronized(self)
  {
    if (defaultDataBase == nil)
    {
      defaultDataBase = [[[self class] alloc] init];
    }
  }
  
  return defaultDataBase;
}

///////////////// Static
- (void)judgeToRemoveStaticOfOutOfTime {
  [self judgeToRemoveOutOfTime:@"Static"];
}

- (BOOL)resetTableOfStatics {
  return [self resetTable:@"Static"];
}

- (BOOL)addOneStaticWithTime:(NSString *)time
                     version:(NSString *)version
                     network:(NSString *)network
                  operatorer:(NSString *)operatorer {
  BOOL ret = NO;
  ret = [_db executeUpdate:@"insert into Static (appversion, runtime, network, operatorer) values(?, ?, ?, ?)",
         version,
         time,
         network,
         operatorer];
  
  return ret;
}

- (NSMutableDictionary *)achiveAllStatics {
  FMResultSet *rs = [_db executeQuery:@"select * from Static"];
  
  if (rs !=nil) {
    NSMutableDictionary *uploadContent = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    NSDictionary *phone = @{@"deviceid" : [CommUtls getUniqueIdentifier],
                            @"platform" : UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"5" : @"0",
                            @"version"  : [CommUtls getSystemVersion],
                            @"brand"    : [CommUtls getModel],
                            @"resolution" : [CommUtls getResolution]};
    [uploadContent setObject:phone forKey:@"phone"];
    
    NSMutableArray *statics = [[NSMutableArray alloc] init];
    while ( [rs next] )
    {
      NSMutableDictionary * aStaticInfo = [[NSMutableDictionary alloc] initWithCapacity:4];
      [aStaticInfo setValue:[rs stringForColumn:@"appversion"] forKey:@"appversion"];
      [aStaticInfo setValue:[rs stringForColumn:@"runtime"] forKey:@"runtime"];
      [aStaticInfo setValue:[rs stringForColumn:@"network"] forKey:@"network"];
      [aStaticInfo setValue:[rs stringForColumn:@"operatorer"] ? [rs stringForColumn:@"operatorer"] : @"simulator" forKey:@"operatorer"];
      
      [statics addObject:aStaticInfo];
    }
    
    [uploadContent setObject:statics forKey:@"apprun"];
    
    if (statics.count > 0) {
      return uploadContent;
    } else {
      return nil;
    }
  }
  
  return nil;
}


- (instancetype)init {
  if (self = [super init]) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *cachesDbDirectory= [paths objectAtIndex:0];
    NSString *path = [cachesDbDirectory stringByAppendingPathComponent:@"STATIC.db"];
    
    self.db = [FMDatabase databaseWithPath:path];
    if ([_db open]) {
      [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS Static (_id INTEGER primary key autoincrement, appversion varchar(64), runtime varchar(16), network varchar(16), operatorer varchar(16))"];
    }
  }
  return self;
}

- (void)closeDataBase {
  [self.db close];
}

#pragma mark - Private -
- (void)judgeToRemoveOutOfTime:(NSString *)tableName {
  FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from %@", tableName]];
  if (rs !=nil) {
    while ( [rs next] )
    {
      NSInteger count = [rs intForColumnIndex:0];
      
      if (count > 100) {
        [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE _id IN (SELECT _id FROM %@ ORDER BY _id ASC LIMIT %d);", tableName, tableName, count-100]];
      }
    }
  }
}

- (BOOL)resetTable:(NSString *)tableName {
  BOOL ret = NO;
  
  ret = [_db executeUpdate:[NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq = 0 WHERE name = '%@';", tableName]];
  ret = [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", tableName]];
  return ret;
}



@end
