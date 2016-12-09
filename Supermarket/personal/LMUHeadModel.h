//
//  LMUHeadModel.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/4.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <BaseWithRAC/BaseWithRAC.h>

@interface LMUHeadModel : BaseModel
@property(nonatomic,strong)NSString*imagePath;
@property(nonatomic,strong)NSString*username;
@property(nonatomic,strong)NSString*userGender;
@property(nonatomic,assign)NSInteger*age;
@end
