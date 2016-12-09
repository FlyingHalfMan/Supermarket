//
//  GFSH_TopicModel.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GFSH_BaseModel.h"

@interface GFSH_TopicModel : GFSH_BaseModel

@property (nonatomic, assign) NSInteger index;          //!题号

@property (nonatomic, strong) UIImage *img;             //!答疑的"问"图片

@end
