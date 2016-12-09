//
//  GFSH_PracticeView.m
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/20.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import "GFSH_PracticeView.h"
#import "GFSH_BaseView.h"

@implementation GFSH_PracticeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)draw
{
    CGFloat height = 0.f;
    if (self.topic) {
        GFSH_BaseView *bv = [[GFSH_BaseView alloc]initWithFrame:self.bounds];
        [bv drawWith:self.topic];
        height += bv.frame.size.height;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
        [self addSubview:bv];
    }
    if (self.options) {
        for (GFSH_OptionModel *om in self.options) {
            GFSH_BaseView *bv = [[GFSH_BaseView alloc]initWithFrame:CGRectMake(0, height+10, self.frame.size.width, 0)];
            [bv drawWith:om];
            height += bv.frame.size.height+5;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
            [self addSubview:bv];
        }
    }
    if (self.analysis) {

    }
}

@end
