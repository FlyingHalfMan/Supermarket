//
//  LMUPersonalViewModel.h
//  Supermarket
//
//  Created by DL on 16/11/3.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMUPersonalViewModel : BaseViewModel
@property(nonatomic,copy)NSString* userId;
@property(nonatomic,copy)NSString* birthdate;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* gender;
@property(nonatomic,copy)NSString* homeAddress;
@property(nonatomic,copy)NSString* workAddress;
@property(nonatomic)UIImage* image;
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* occupation;
@property(nonatomic,copy)NSString* registDate;
@property(nonatomic,copy)NSString* role;

@property(nonatomic,strong)RACSubject* imageUpdateSignal;
@property(nonatomic,strong) RACSubject* uploadSigna;

-(BOOL)isLogin;
-(UserProfile*)getUserInfor;
-(void)updateUserInfor;
-(void)VerifyName:(NSString*)name;                                // 验证用户名是否有效
-(void)getUserImageHeight:(int) height Width:(int)width;          // 根据图片尺寸来获取图片
-(void)uploadImage:(UIImage*)imageName;                           // 上传图片

-(void)updateImage:(NSString*)imageName;                          // 更新图片
-(void)updaeName:(NSString*)name;                                 // 更新姓名
-(void)updateGender:(NSString*)gender;                            // 更新性别
-(void)updateMobile:(CountVerifyCode*)countVerifyCode;            // 更新手机
-(void)updateEmail:(CountVerifyCode*)countVerifyCode;             // 更新邮箱
-(void)updateOccupation:(NSString*)occupation;                    // 更新职业
-(void)updateHomeAddress:(NSString*)homeAddress;                  // 更新家庭地址
-(void)updateWorkAddress:(NSString*)workAddress;                  // 更新工作地址
-(void)updateName:(NSString*)name;                                // 更新姓名
-(void)updateBirthday:(BirthdayModel*)birthday;                   // 更新出生日期
-(void)updatePassword:(ResetPasswordModel*)resetPasswordModel;    // 更新密码


-(void)loadData;

-(void)getProvinces;
-(void)getCitiesByProvinceId:(NSInteger)provinceId;
-(void)getAreasByCityId:(NSInteger)cityId;
@end
