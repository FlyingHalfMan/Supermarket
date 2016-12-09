//
//  CommUtls+File.h
//  CdeleduUtls
//
//  Created by 陈轶翔 on 14-3-30.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import "CommUtls.h"

@interface CommUtls (File)


//文件路径是否存在
+ (BOOL)fileExists:(NSString *)fullPathName;

//根据文件路径删除文件
+ (BOOL)remove:(NSString *)fullPathName;

//创建文件
+ (void)makeDirs:(NSString *)dir;

//documentPath路径是否存在
+ (BOOL)fileExistInDocumentPath:(NSString*)fileName;

//返回完整的documentPath下文件路径
+ (NSString*)documentPath:(NSString*)fileName;

//删除documentPath路径下文件
+ (BOOL)deleteDocumentFile:(NSString*)fileName;

//cachePath路径是否存在
+ (BOOL)fileExistInCachesPath:(NSString*)fileName;

//返回完整的cachePath下文件路径
+ (NSString*)cachesFilePath:(NSString*)fileName;

//删除cachePath下文件路径
+ (BOOL)deleteCachesFile:(NSString*)fileName;


//增加icloud不被备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;


@end
