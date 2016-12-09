//
//  GFSH_BaseView.h
//  DrawPractice&Question
//
//  Created by gfsh on 14/11/6.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFSH_BaseModel.h"
@interface GFSH_BaseView : UIView <UIGestureRecognizerDelegate>

- (void)drawWith:(GFSH_BaseModel *)model;

@end
