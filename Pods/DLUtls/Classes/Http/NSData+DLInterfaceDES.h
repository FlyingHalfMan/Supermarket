//
//  NSData+DES.h
//  CdelQuestions
//
//  Created by gfsh on 15/10/19.
//  Copyright © 2015年 Gao Fusheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DLInterfaceDES)

- (NSString *)DL_base64Encoding;

+ (NSData *)DL_dataWithBase64EncodedString:(NSString *)string;

+ (NSData *)DL_DESEncrypt:(NSData *)data WithKey:(NSString *)key;

+ (NSData *)DL_DESDecrypt:(NSData *)data WithKey:(NSString *)key;

@end
