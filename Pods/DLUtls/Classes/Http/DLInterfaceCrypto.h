//
//  DLInterfaceCrypto.h
//  Pods
//
//  Created by SL on 15/10/20.
//
//

#import <Foundation/Foundation.h>

@interface DLInterfaceCrypto : NSObject

+ (NSString *)DL_DESEncrypt:(NSString *)origin
                    withKey:(NSString *)withKey;

+ (NSString *)DL_DESDecrypt:(NSString *)ciphertext
                    withKey:(NSString *)withKey;

@end
