//
//  BaseModel.m
//  MobileClassPhone
//
//  Created by Bryce on 14/12/8.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

+ (LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *dbName = [self DBName];
        if(dbName == nil)
            dbName = @"MobileClass.db";
        NSString *filePath = [LKDBUtils getPathForDocuments:dbName];
        sharedInstance = [[LKDBHelper alloc] initWithDBPath:filePath];
    });
    return sharedInstance;
}

+ (NSDictionary *)getTableMapping{
    NSCAssert([self tableMapping] != nil, @"BaseModel Error:tableMapping未实现");
    return [self tableMapping];
}

+ (NSDictionary *)tableMapping{
    //    if ([self getTableName]) {
    //        return [MobileSQLManage getTableMapping:[self getTableName]];
    //    }
    return nil;
}

//去除空格
- (void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSString class]]) {
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    [super setValue:value forKey:key];
}

//防止服务器返回[NSNull null]时属性值为NSInteger的时候出错的情况
- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key]; // For NSInteger/CGFloat/BOOL
}

+ (id)modelFromJSONDictionary:(NSDictionary *)data{
    return [MTLJSONAdapter modelOfClass:[self class]
                     fromJSONDictionary:data
                                  error:nil];
}

+ (id)modelsFromJSONArray:(NSArray *)array{
    return [MTLJSONAdapter modelsOfClass:[self class]
                           fromJSONArray:array
                                   error:nil];
}

+ (NSString *)DBName
{
    return nil;
}


@end
