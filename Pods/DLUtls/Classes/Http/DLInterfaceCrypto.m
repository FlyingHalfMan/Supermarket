//
//  DLInterfaceCrypto.m
//  Pods
//
//  Created by SL on 15/10/20.
//
//

#import "DLInterfaceCrypto.h"
#import "NSData+DLInterfaceDES.h"

@implementation DLInterfaceCrypto

+ (NSString *)DL_DESEncrypt:(NSString *)origin
                    withKey:(NSString *)withKey{
    if (!origin) {
        return origin;
    }
    NSData *data = [origin dataUsingEncoding:NSUTF8StringEncoding];
    NSData *endata = [NSData DL_DESEncrypt:data WithKey:withKey];
    NSString *base64 = [endata DL_base64Encoding];
    return [[[base64 stringByReplacingOccurrencesOfString:@"+" withString:@"."]stringByReplacingOccurrencesOfString:@"/" withString:@"-"]stringByReplacingOccurrencesOfString:@"=" withString:@"_"];
}

+ (NSString *)DL_DESDecrypt:(NSString *)ciphertext
                    withKey:(NSString *)withKey{
    if (!ciphertext) {
        return ciphertext;
    }
    ciphertext = [[[ciphertext stringByReplacingOccurrencesOfString:@"." withString:@"+"]stringByReplacingOccurrencesOfString:@"-" withString:@"/"]stringByReplacingOccurrencesOfString:@"_" withString:@"="];
    NSData *data = [NSData DL_dataWithBase64EncodedString:ciphertext];
    NSData *dedata = [NSData DL_DESDecrypt:data WithKey:withKey];
    NSString *desStr = [[NSString alloc]initWithData:dedata encoding:NSUTF8StringEncoding];
    return desStr;
}

@end
