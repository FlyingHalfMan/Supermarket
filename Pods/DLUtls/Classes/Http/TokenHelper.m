//
//  DLTokenHelper.m
//  Pods
//
//  Created by SL on 16/8/5.
//
//

#import "TokenHelper.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NetStatusHelper.h"
#import "DLHttpRACHelp.h"
#import "DLHttpUtls.h"
#import <JSONKit-NoWarning/JSONKit.h>
#import "DLInterfaceCrypto.h"
#import "CommUtls+Time.h"
#import "CommUtls+DeviceInfo.h"
#import "HttpNetworking.h"
#import <MD5Digest/NSString+MD5.h>

@interface DLTokenInfo()

@property (nonatomic,assign) long long longtime;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger timeout;

@end

@implementation DLTokenInfo

@end

@interface TokenHelper ()

@end

@implementation TokenHelper

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

+ (instancetype)sharedInstance {
    static TokenHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TokenHelper alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init;{
    self = [super init];
    if(self){
        @weakify(self)
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification
                                                                object:nil] takeUntil:self.rac_willDeallocSignal]
         subscribeNext:^(id x) {
             @strongify(self);
             [self getASynchronousToken];
         }];
        
        [[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kNetStatusHelperChangedNotification object:nil]
           takeUntil:self.rac_willDeallocSignal] filter:^BOOL (id status) {
            return ([NetStatusHelper sharedInstance].netStatus != NoneNet);
        }] subscribeNext:^(NSNotification *notification) {
            @strongify(self);
            [self getASynchronousToken];
        }];
    }
    return self;
}

- (void)getSynchronousToken {
    if (self.netUrl) {
        id response = [DLHttpUtls DLGetSynchronous:self.netUrl parameters:[self getParameters] locationFile:nil];
        if([response isKindOfClass:[NSError class]]) {
            return;
        }
        [self parseValue:response];
    } else {
#ifdef DEBUG
        NSLog(@"\n未设置token请求地址\n未设置token请求地址\n未设置token请求地址\n未设置token请求地址\n未设置token请求地址");
#endif
    }
}

- (void)getASynchronousToken {
    [[self fetchToken] subscribeCompleted:^{
        
    }];
}

- (RACSignal *)fetchToken {
    @weakify(self);
    return [[DLHttpRACHelp GET:self.netUrl params:[self getParameters]]
            tryMap:^id(id value, NSError *__autoreleasing *errorPtr) {
                @strongify(self);
                if ([self parseValue:value]) {
                    return @1;
                }
                return nil;
            }];
}

/**
 *  获取请求参数
 */
- (NSDictionary *)getParameters {
    NSString *time = [CommUtls encodeTime:[NSDate date]];
    NSString *version = [CommUtls getSoftShowVersion];
    NSString *pkeyValue = [[NSString stringWithFormat:@"%@%@%@%@%@",
                            [CommUtls fetchPlatformValue],
                            version,
                            time,
                            @"Nyjh5AEeMw",
                            self.notMobileClass?@"":[HttpNetworking sharedInstance].appkey
                            ] MD5Digest];
    return @{
             @"time":time,
             @"pkey":pkeyValue,
             @"version":version,
             @"platformSource":[CommUtls fetchPlatformValue],
             @"appkey":[HttpNetworking sharedInstance].appkey,
             };
}

/**
 *  解析返回参数
 */
- (BOOL)parseValue:(NSString *)value {
    if (value) {
        NSDictionary *info = [value objectFromJSONString];
        if([info[@"code"]integerValue] == 1) {
            NSDictionary *infoDic = nil;
            if (self.notMobileClass) {
                infoDic = info;
            } else {
                NSString *destr = [DLInterfaceCrypto DL_DESDecrypt:info[@"paramValue"] withKey:@"cdel0927"];
                infoDic = [destr objectFromJSONString];
            }
            DLTokenInfo *model = [DLTokenInfo new];
            model.timeout = [infoDic[@"timeout"] integerValue];
            model.longtime = [infoDic[@"longtime"] longLongValue];
            model.token = [NSString stringWithFormat:@"%@",infoDic[@"token"]];
            self.tokenInfo = model;
            return YES;
        }
    }
    return NO;
}

@end
