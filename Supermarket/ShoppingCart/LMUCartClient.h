//
//  LMUCartClient.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/7.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUCartClient : NSObject

-(RACSignal*)loadDataWithStart:(NSInteger)start limit:(NSInteger)limit;     // 获取购物车商品
-(RACSignal*)deleteCommorityWithMarketId:(NSString*)marketId andCommorityId:(NSString*)commorityId; // 删除某件商品
-(RACSignal*)deleteCommoritiesWithMarketId:(NSString*)marketId;  // 删除某家超市的全部商品
-(RACSignal*)getCommorityInformationWithMarketId:(NSString*)marketId andCommorityId:(NSString*)commorityId;// 查看商品信息
-(RACSignal*)settleCartAll;  // 结算全部购物车
-(RACSignal*)settleCartWithCommorities:(NSMutableArray*)commorities; // 结算多件商品可以不是同一家超市

@end
