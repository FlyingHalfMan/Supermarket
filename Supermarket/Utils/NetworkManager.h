//
//  NetworkManager.h
//  compuslifeAssistance
//
//  Created by Cai.H.F on 7/17/16.
//  Copyright © 2016 com.live.hf_kia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModels.h"
#import "JSONModel.h"
#import <UIKit/UIKit.h>
@interface NetworkManager : NSObject
//@property(nonatomic,weak)NSURLSession* session;
@property(nonatomic) UserProfile* myProfile;
@property(nonatomic) SecurityToken* token;
+(NetworkManager*)sharedManager;
-(BOOL)login;
-(void) logout;
- (NSURLSessionDataTask*)getDataWithUrl:(NSString*)url completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask*)postDataWithUrl:(NSString*)url data:(NSData*)data completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask*)putDataWithUrl:(NSString*)url data:(NSData*)data completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask*)deleteDataWithUrl:(NSString*)url data:(NSData*)data completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask*)requestDataWithUrl:(NSString*)url method:(NSString*)method data:(NSData*)data completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask*)uploadImageWithUrl:(NSString*)url data:(NSData*)data completionHandler:(void(^)(long statusCode, NSData* data, NSString* errorMessage))completionHandler;

- (NSURLSessionDataTask *)getUploadImageWithName:(NSString *)name completionHandler:(void (^)(long statusCode, NSData * data))completionHandler;

- (NSURLSessionDataTask *)getResizedImageWithName:(NSString *)name dimension:(int)dimension completionHandler:(void (^)(long statusCode, NSData * data))completionHandler;
- (NSURLSessionDataTask *)getResizedImageWithName:(NSString *)name extention:(NSString*)ext height:(int)height width:(int)width completionHandler:(void (^)(long statusCode, NSData *data))completionHandler;

@end
