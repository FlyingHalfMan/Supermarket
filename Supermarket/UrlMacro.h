//
//  UrlMacro.h
//  Supermarket
//
//  Created by caihongfeng on 2016/12/4.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#ifndef UrlMacro_h
#define UrlMacro_h

static NSString* loginwithPasswordUrl = @"login/password";
static NSString* loginwithVerifyCode =@"login/verifyCode";
static NSString* getLoginVerifyCodeUrl =@"/login/";
static NSString* userProfileUrl = @"/user";
static NSString* verifyCountUrl  =@"检测帐号是否正确的URL";
static NSString* CountRegistUrl = @"检查帐号是否注册url";
static NSString* loadProfileUrl = @"/user";                         // 获取用户信息
static NSString* logoutUrl = @"/logout";
static NSString* verifyCodeUrl = @"/regist/verifycode/";            // 获取注册验证吗
static NSString* registURL = @"/regist";                            // 注册
static NSString* loginWithPasswordUrl = @"/login/password";         // 密码登录
static NSString* uploadImageURL = @"/resource/upload/image";         // 上传头像
static NSString* updateImage = @"/user/update/image"  ;              // 更新头像
static NSString* updateEmailURL = @"/user/update/email";             // 更新邮箱
static NSString* updateMobileURL =@"/user/update/mobile";           // 更新手机
static NSString* updateGenderURL = @"/user/update/gender";          // 更新性别
static NSString* updatePwdVerifyCodeURL = @"/login/password/verifycode";         // 更新密码验证码
static NSString* updatePassword = @"/user/update/password";         // 更新密码
static NSString* updateOccupationURL = @"user/update/occupation";  // 更新职业
static NSString* verifyNameURL = @"user/verifyname"  ;              // 验证姓名
static NSString* updateNameURL = @"/user/update/name";               // 更新姓名
static NSString* updateBirthday = @"user/update/birthdate" ;        // 更新出生日期
static NSString* updateHomeAddress = @"user/update/homeaddress";       // 更新家庭地址
static NSString* updateWorkAddress = @"user/udpate/workaddress";

static NSString* commorityFirstCategory = @"other/category";//获取超市商品分类
static NSString* commoritySecondCategory = @"other/category/item/";// 获取超市商品二级分类
static NSString* provinceURL = @"other/location/province";//获取省份

static NSString* cityURL = @"other/location/city/";// 获取市
static NSString* areaURL = @"other/location/area";// 获取地区
#endif /* UrlMacro_h */
