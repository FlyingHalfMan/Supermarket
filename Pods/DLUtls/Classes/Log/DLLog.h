//
//  DLLog.h
//  Pods
//
//  Created by cyx on 15/4/21.
//
//

#import <Foundation/Foundation.h>

@interface DLLog : NSObject

@property (nonatomic,assign)BOOL isUseLog;
@property (nonatomic,assign)BOOL isGlobalLog;

+ (DLLog *)sharedInstance;

+ (void)info:(NSString *)format, ...;

//+ (void)error:(NSString *)format, ...;

+ (void)globalInfo:(NSString *)format, ...;

//+ (void)globalErro:(NSString *)format, ...;

+ (NSArray *)fetchLoggingMsg;

+ (void)clearLoggingMsg;

@end
