//
//  NetStatusHelper.h
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NetStatus)
{
    NoneNet = 0,//没有网络
    Mobile_Net = 1,//移动网络
    Wifi_Net = 2 //局域网络
};

extern NSString *const kNetStatusHelperChangedNotification;


@interface NetStatusHelper : NSObject


/**
 *  获取单例
 *
 *  @return <#return value description#>
 */
+ (NetStatusHelper *)sharedInstance;

- (void)startNotifier;

- (NetStatus)getSyNetStatus;


@property (assign,readonly,atomic)NetStatus netStatus;

@end
