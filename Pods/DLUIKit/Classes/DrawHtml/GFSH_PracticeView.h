//
//  GFSH_PracticeView.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFSH_TopicModel.h"
#import "GFSH_OptionModel.h"
#import "GFSH_AnalysisModel.h"

@interface GFSH_PracticeView : UIView

@property (nonatomic, strong) GFSH_TopicModel *topic;            //!题干

@property (nonatomic, strong) NSArray *options;             //!选项

@property (nonatomic, strong) GFSH_AnalysisModel *analysis;      //!答案及分析

- (void)draw;

@end
