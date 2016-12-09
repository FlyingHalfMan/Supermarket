//
//  GFSH_BaseModel.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/11/5.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GFSH_BaseModel : NSObject

@property (nonatomic, strong) UIFont *font;                 //!字体

@property (nonatomic, strong) UIColor *color;               //!字体颜色

@property (nonatomic, copy) NSString *content;              //!内容(html字符串)

@property (nonatomic, strong) UIImage *defaultTableImg;     //!默认表格的图片

@end
