//
//  HeaderItemViewModel.m
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "HeaderItemViewModel.h"

@implementation HeaderItemViewModel


-(instancetype)initWithImage:(NSString *)image Name:(NSString *)name{

    self = [super init];
    if(self){
        _imageName = image;
        _name = name;
    }
    return self;
}
@end
