//
//  LMUSearcHistoryModel.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearcHistoryModel.h"

@implementation LMUSearcHistoryModel


-(instancetype)initWithText:(NSString*)text{
    self=[super init];
    if (self) {
        _content = text;
        _date = [NSDate date];
    }
    return self;
}
@end

@implementation SearchResults
@end
