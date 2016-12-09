//
//  RegistService.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistService : NSObject

-(RACSignal*)getRegistVerifyCode:(NSString*)contact;
-(RACSignal*)regitWithContact:(NSString*)contact andVerifyCode:(NSString*)verifyCode;

@end
