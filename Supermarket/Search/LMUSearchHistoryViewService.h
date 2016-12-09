//
//  LMUSearchHistoryViewService.h
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUSearchHistoryViewService : NSObject

-(RACSignal*)loadData;
-(RACSignal*)searchWithText:(NSString*)text andType:(NSInteger)type;
@end
