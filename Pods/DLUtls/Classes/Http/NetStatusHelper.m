//
//  NetStatusHelper.m
//  MobileClassPhone
//
//  Created by cyx on 14/12/4.
//  Copyright (c) 2014年 CDEL. All rights reserved.
//

#import "NetStatusHelper.h"
#import <Reachability/Reachability.h>

NSString *const kNetStatusHelperChangedNotification = @"kNetStatusHelperChangedNotification";


@implementation NetStatusHelper

static NetStatusHelper *sharedObj = nil;

+ (NetStatusHelper* )sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

- (id)init
{
    self =  [super init];
    _netStatus = NoneNet;
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (NetStatus)getSyNetStatus
{
    @try {
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if( status == ReachableViaWiFi)
        {
            _netStatus = Wifi_Net;
            return Wifi_Net;
        }
        else if( status == ReachableViaWWAN)
        {
            _netStatus = Mobile_Net;
            return Mobile_Net;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
    return _netStatus;
}

- (void)startNotifier
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [[Reachability reachabilityWithHostName:@"www.baidu.com"] startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            _netStatus = NoneNet;
            break;
        case ReachableViaWiFi:
            _netStatus = Wifi_Net;
            break;
        case ReachableViaWWAN:
            _netStatus = Mobile_Net;
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetStatusHelperChangedNotification object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:_netStatus ],@"netstatus", nil]];
}


@end
