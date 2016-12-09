//
//  DLHttpRACHelp.m
//  Pods
//
//  Created by SL on 16/7/26.
//
//

#import "DLHttpRACHelp.h"
#import "DLHttpUtls.h"
#import "NetStatusHelper.h"

#ifdef DEBUG
#define DLHttpLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DLHttpLog(format, ...)
#endif

@interface DLHttpRACHelp ()

@end

@implementation DLHttpRACHelp

- (void)dealloc {
    DLHttpLog(@"dealloc -- %@",self.class);
}

/**
 *  网络异常状态信号
 */
+ (RACSignal *)fetchNetStatus {
    if ([NetStatusHelper sharedInstance].netStatus == NoneNet) {
        NSError *error = [NSError errorWithDomain:@"com.cdeledu.err" code:-1001 userInfo:@{@"errorInfo":@"无网络"}];
        return [RACSignal error:error];
    }
    return nil;
}

+ (RACSignal *)GET:(NSString *)url params:(id)params {
    RACSignal *signal = [self fetchNetStatus];
    if (!signal) {
        signal = [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            DLCancelBolck cancelBlock = [DLHttpUtls DLGetAsynchronous:url
                                                           parameters:params
                                                         locationFile:nil
                                                             complete:^(NSString *str) {
                                                                 DLHttpLog(@"接口返回：%@--%@",url,str);
                                                                 [subscriber sendNext:str];
                                                                 [subscriber sendCompleted];
                                                             } fail:^(NSError *err) {
                                                                 DLHttpLog(@"接口错误：%@--%@",url,err);
                                                                 [subscriber sendError:err];
                                                             }];
            return [RACDisposable disposableWithBlock:^{
                cancelBlock();
            }];
        }];
    }
    return signal;
}

+ (RACSignal *)POST:(NSString *)url params:(id)params {
    RACSignal *signal = [self fetchNetStatus];
    if (!signal) {
        signal = [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            DLCancelBolck cancelBlock = [DLHttpUtls DLPostAsynchronous:url
                                                            parameters:params
                                                          locationFile:nil
                                                              complete:^(NSString *str) {
                                                                  DLHttpLog(@"接口返回：%@--%@",url,str);
                                                                  [subscriber sendNext:str];
                                                                  [subscriber sendCompleted];
                                                              } fail:^(NSError *err) {
                                                                  DLHttpLog(@"接口错误：%@--%@",url,err);
                                                                  [subscriber sendError:err];
                                                              }];
            return [RACDisposable disposableWithBlock:^{
                cancelBlock();
            }];
        }];
    }
    return signal;
}

+ (RACSignal *)UPLOAD:(NSString *)url
               params:(id)params
                files:(NSArray *)files
             fileData:(NSData *)fileData
             fileName:(NSString *)fileName {
    RACSignal *signal = [self fetchNetStatus];
    if (!signal) {
        signal = [RACSignal createSignal:^RACDisposable *(id < RACSubscriber > subscriber) {
            DLCancelBolck cancelBlock = [DLHttpUtls DLUploadAsynchronous:url
                                                              parameters:params
                                                                   files:files
                                                                fileData:fileData
                                                                fileName:fileName
                                                            locationFile:nil
                                                                complete:^(NSString *str) {
                                                                    DLHttpLog(@"接口返回：%@--%@",url,str);
                                                                    [subscriber sendNext:str];
                                                                    [subscriber sendCompleted];
                                                                } fail:^(NSError *err) {
                                                                    DLHttpLog(@"接口错误：%@--%@",url,err);
                                                                    [subscriber sendError:err];
                                                                }];
            return [RACDisposable disposableWithBlock:^{
                cancelBlock();
            }];
        }];
    }
    return signal;
}

@end
