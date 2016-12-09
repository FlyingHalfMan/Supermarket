//
//  LMUHomeService.h
//  Supermarket
//
//  Created by DL on 2016/11/20.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUHomeService : NSObject
-(RACSignal*)loadDataWithUrl:(NSString*)url offset:(NSInteger)offset limit:(NSInteger)limit;

-(RACSignal*)loadCategoryData;
@end
