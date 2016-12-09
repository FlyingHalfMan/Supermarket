//
//  UserClient.h
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModels.h"
@interface UserClient : NSObject


-(BOOL)isLogin;
-(UserProfile*)getUserInfor;
-(RACSignal*)updateUserInfor;
-(RACSignal*)VerifyName:(NSString*)name;                                // 验证用户名是否有效
-(RACSignal*)getUserImageHeight:(int) height Width:(int)width;          // 根据图片尺寸来获取图片
-(RACSignal*)uploadImage:(UIImage*)imageName;                           // 上传图片

-(RACSignal*)updateImage:(NSString*)image;                              // 更新图片
-(RACSignal*)updaeName:(NSString*)name;                                 // 更新姓名
-(RACSignal*)updateGender:(NSString*)gender;                            // 更新性别
-(RACSignal*)updateMobile:(CountVerifyCode*)countVerifyCode;            // 更新手机
-(RACSignal*)updateEmail:(CountVerifyCode*)countVerifyCode;             // 更新邮箱
-(RACSignal*)updateOccupation:(NSString*)occupation;                    // 更新职业
-(RACSignal*)updateHomeAddress:(NSString*)homeAddress;                  // 更新家庭地址
-(RACSignal*)updateWorkAddress:(NSString*)workAddress;                  // 更新工作地址
-(RACSignal*)updateName:(NSString*)name;                                // 更新姓名
-(RACSignal*)updateBirthday:(BirthdayModel*)birthday;                   // 更新出生日期
-(RACSignal*)updatePassword:(ResetPasswordModel*)resetPasswordModel;    // 更新密码


-(RACSignal*)getProvinces;
-(RACSignal*)getCitiesByProvinceId:(NSInteger)provinceId;
-(RACSignal*)getAreasByCityId:(NSInteger)cityId;

@end
