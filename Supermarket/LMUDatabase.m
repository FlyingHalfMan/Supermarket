//
//  LMUDatabase.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUDatabase.h"

@implementation LMUDatabase

-(instancetype)init{

    self = [super init];
    if (self) {
//        NSString* dbPath =[[NSBundle mainBundle]pathForResource:@"supermarket" ofType:@"db"];
//        _database = [FMDatabase databaseWithPath:dbPath];
//        if ([_database open]) {
//            CLog(@"LMUDatabase:init:数据库开启失败");
//        }
//        if ([self isTableNil]) {
//            [self CreateTable];
//        }
    }

    return  self;


}
////数据库中是否有表格
//-(BOOL)isTableNil{
//    int count=0;
//    NSString* query = @"select count(table_name) from user_tables;";
//    FMResultSet* rs =[_database executeQuery:query];
//    while (rs.next) {
//        count = [rs intForColumnIndex:0];
//    }
//    
//    if (count ==0) {
//        return YES;
//    }
//    else return NO;
//    
//
//}
//
//-(void)CreateTable{
//    
//    //创建个人信息表
//    NSString* createUserTable = @"create table user(userId text PrimaryKey,birthdate NUMERIC,email text,gender text,homeAddress text,workAddress text,image text,mobile text, name text,occupation text,registDate NUMERIC, role INTERGER)";
//
//    [_database executeUpdate:createUserTable];
//    
//    //创建登陆信息表
//    
//    NSString* createSecurityToken =@"create table securityToken(userid text PrimaryKey,securityToken text,expiredDate NUMERIC)";
//     [_database executeUpdate:createSecurityToken];
//    
//    //创建搜索记录表
//    NSString* createSearchHistory =@"create table searchHistory(id INTEGER PRIMARYKEY,content text)";
//    [_database executeUpdate:createSearchHistory];
//    
//
//
//
//}
@end
