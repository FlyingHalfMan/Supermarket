//
//  GFSH_AnalysisModel.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFSH_BaseModel.h"

@interface GFSH_AnalysisModel : GFSH_BaseModel

@property (nonatomic, copy) NSString *answer;             //!正确答案

@property (nonatomic, copy) NSString *analysis;           //!答案解析

@property (nonatomic, assign) NSInteger time;               //!做题时间

@property (nonatomic, copy) NSString *level;              //!做题时间级别

@property (nonatomic, copy) NSString *easyErrorOpt;       //!易错项

@property (nonatomic, copy) NSString *rightPercent;       //!正确率

@end
