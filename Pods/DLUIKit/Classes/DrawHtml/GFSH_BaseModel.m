//
//  GFSH_BaseModel.m
//  DrawPractice&Question
//
//  Created by gfsh on 14/11/5.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import "GFSH_BaseModel.h"

@implementation GFSH_BaseModel

- (instancetype)init
{
    if (!self)
        return nil;
    self.font = [UIFont systemFontOfSize:15];
    self.color = [UIColor grayColor];
    return self;
}

@end
