//
//  DataConversionClass.h
//  ContinueEDUPhone
//  XML数据格式转字典
//  Created by SL on 13-11-27.
//  Copyright (c) 2013年 Sheng Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConversionClass : NSObject

/**
 *  XML Data 转换成字典
 *
 *  @param data  XML Data
 *  @param array 已知XML字段为数组的节点名称，以免该节点只有一条信息时候返回非数组数据
 *
 *  @return 字典对象
 */
+ (NSDictionary *)XMLDataToDic:(NSData*)data arrayName:(NSArray*)array;

@end
