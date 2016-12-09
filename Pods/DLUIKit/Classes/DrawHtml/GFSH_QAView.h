//
//  GFSH_QAView.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFSH_TopicModel.h"
#import "GFSH_AnswerModel.h"

@interface GFSH_QAView : UIView

@property (nonatomic, strong) GFSH_TopicModel *topic;            //!问题

@property (nonatomic, strong) GFSH_AnswerModel *answer;          //!回答

@end
