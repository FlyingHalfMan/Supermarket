//
//  HeaderItemViewModel.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <BaseWithRAC/BaseWithRAC.h>

@interface HeaderItemViewModel : BaseViewModel
@property(nonatomic,copy)NSString* imageName;
@property(nonatomic,copy)NSString* name;

-(instancetype)initWithImage:(NSString*)image Name:(NSString*)name;
@end
