//
//  BaseModel.h
//  MobileClassPhone
//
//  Created by Bryce on 14/12/8.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <LKDBHelper/LKDBHelper.h>
#import <Mantle/Mantle.h>

@protocol BaseModelDelegate <NSObject>
@required
+ (NSDictionary *)tableMapping;

+ (NSString *)DBName;

@end

@interface BaseModel : MTLModel<BaseModelDelegate,MTLJSONSerializing>

/**
 *  字典转对象
 */
+ (id)modelFromJSONDictionary:(NSDictionary *)data;

/**
 *  数组转对象
 */
+ (id)modelsFromJSONArray:(NSArray *)array;

@end
