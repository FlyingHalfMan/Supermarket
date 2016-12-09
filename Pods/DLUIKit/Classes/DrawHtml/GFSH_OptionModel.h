//
//  GFSH_OptionModel.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GFSH_BaseModel.h"

@interface GFSH_OptionModel : GFSH_BaseModel

@property (nonatomic, assign) NSInteger index;              //!选项索引

@property (nonatomic, strong) UIImage *normalImg;           //!选项图片：正常

@property (nonatomic, strong) UIImage *selectedImg;         //!选项图片：选中

@property (nonatomic, assign) BOOL isSelected;              //!是否选中

@end
