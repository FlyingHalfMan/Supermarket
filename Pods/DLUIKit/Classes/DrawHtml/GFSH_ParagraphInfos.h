//
//  GFSH_ParagraphInfos.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/29.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GFSH_BaseModel.h"

@interface GFSH_ParagraphInfos : NSObject

@property (nonatomic, strong) NSMutableAttributedString *attrStrs;          //解析后属性字符串

@property (nonatomic, strong) NSMutableArray *tableInfos;                   //表格的infos

@property (nonatomic, strong) NSMutableArray *imgInfos;                     //图片的infos

@property (nonatomic, assign) CGSize size;                                  //当前段落的size

- (void)parserHtml:(GFSH_BaseModel *)model atWidth:(CGFloat)width;

@end


@interface TableInfo : NSObject

@property (nonatomic, copy) NSString *indexKey;

@property (nonatomic, copy) NSString *html;

@property (nonatomic, assign) CGRect rect;

@end

@interface ImgInfo : NSObject

@property (nonatomic, copy) NSString *imgName;

@property (nonatomic, copy) NSString *path;

@property (nonatomic, assign) CGRect rect;

@end