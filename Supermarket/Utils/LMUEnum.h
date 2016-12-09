//
//  LMUEnum.h
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUEnum : NSObject


typedef enum{
    ORDERTYPEALL,        // 全部订单
    ORDERTYPEUNPAID,    //未付款订单
    ORDERTYPEUNDELIVE,  //未发货订单
    ORDERTYPEUNRECEIPT, //未收货订单
    ORDERTYPEUNEVALUAT, //未评价订单
    ORDERTYPESERVICE    //售后订单
}OrderType;

typedef enum{
    COUNTTYPEMOBILE,    //手机
    COUNTTYPEEMAIL,     //邮箱
    COUNTTYPENONE       //错误格式
}CountType;
@end
