//
//  HomeCommorityModel.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeCommorityModel : JSONModel
@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,assign)float price;
@property(nonatomic,assign)Inventory_Status satusl;
@property(nonatomic,copy)NSString* image;

@end
