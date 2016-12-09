//
//  UserModels.h
//  附近超市
//
//  Created by Cai.H.F on 9/19/16.
//  Copyright © 2016 cn.programingmonkey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface UserProfile : JSONModel
@property(nonatomic)NSString* userId;
@property(nonatomic)NSDate<Optional>* birthdate;
@property(nonatomic)NSString<Optional>* email;
@property(nonatomic)NSString* gender;
@property(nonatomic)NSString<Optional>* homeAddress;
@property(nonatomic)NSString<Optional>* workAddress;
@property(nonatomic)NSString<Optional>* image;
@property(nonatomic)NSString<Optional>* mobile;
@property(nonatomic)NSString* name;
@property(nonatomic)NSString<Optional>* occupation;
@property(nonatomic)NSDate* registDate;
@property(nonatomic)int role;

@end
@interface SecurityToken : JSONModel
@property(nonatomic)NSString* user_id;
@property(nonatomic)NSString* user_securityToken;
@property(nonatomic)NSDate* expiredDate;

@end

@interface NamePassword : JSONModel
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* password;

@end

@interface CountPassword : JSONModel
@property(nonatomic,copy) NSString* contact;
@property(nonatomic,copy) NSString* password;
@end

@interface CountVerifyCode :JSONModel
@property(nonatomic,copy)NSString* contact;
@property(nonatomic,copy)NSString* verifyCode;
@end

@interface ResetPasswordModel : JSONModel
@property(nonatomic,copy)NSString* contact;
@property(nonatomic,copy)NSString* verifyCode;
@property(nonatomic,copy)NSString* password;
@end

@interface BirthdayModel : JSONModel
@property(nonatomic)NSDate*date;
@end


