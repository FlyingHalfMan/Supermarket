//
//  UserClient.m
//  Supermarket
//
//  Created by DL on 16/11/12.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "UserClient.h"
#import "LMUHeadModel.h"
#import "Models.h"
@implementation UserClient

-(BOOL)isLogin{
    
    //判断用户是否登陆
    return [[NetworkManager sharedManager]login];
    

}

-(UserProfile *)getUserInfor{

    return nil;

}

// 获取给定尺寸的图片宽高
-(RACSubject *)getUserImageWithHeight:(int) height Width:(int)width{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"load image"];
    UserProfile* profile = [[NetworkManager sharedManager]myProfile];
    [[NetworkManager sharedManager ]getResizedImageWithName:profile.image extention:@".jpg" height:height width:width completionHandler:^(long statusCode, NSData *data) {
        if (statusCode ==200) {
           [subject sendNext:[UIImage imageWithData:data]];
        }
        else [subject sendNext:[UIImage imageNamed:@"no_photo"]];
    }];
    return subject;
}

-(RACSignal *)updateUserInfor{
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update user infor"];
    return subject;
}

// 获取头部显示信息
-(RACSignal*)getHeadInfor{
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"head infor"];
    UserProfile* profile = [[NetworkManager sharedManager]myProfile];
    LMUHeadModel* headModel = [[LMUHeadModel alloc]init];
    headModel.imagePath = profile.image;
    headModel.username = profile.name;
    headModel.userGender = profile.gender;
    
    [subject sendNext:headModel];
    return subject;
}

// 上传图片
-(RACSignal *)uploadImage:(UIImage *)image{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"upload Image"];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    if (imageData == nil) {
        imageData = UIImageJPEGRepresentation(image, 0.9f);
    }
    
    [[NetworkManager sharedManager]uploadImageWithUrl:uploadImageURL data:imageData completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {

        if (statusCode ==200) {
            NSError* error;
            ImageModel* imageModel =[[ImageModel alloc]initWithData:data error:&error];
            if (error ==nil) {
                CLog(@"upload complete");
                [subject sendNext:imageModel.imageName];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}

-(RACSignal*)updateImage:(NSString*)image{
    
    updateImage = [updateImage stringByAppendingPathComponent:image];
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"updateImge"];
    [[NetworkManager sharedManager]getDataWithUrl:updateImage completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
       
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc]initWithData:data error:&error];
            if (error ==nil) {
                NSLog(@"image updated");
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"头像更新成功"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}

// 更新email
-(RACSignal *)updateEmail:(CountVerifyCode *)countVerifyCode{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update email"];
    
    [[NetworkManager sharedManager]postDataWithUrl:updateEmailURL data:[countVerifyCode toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    return subject;
}

// 更新性别
-(RACSignal *)updateGender:(NSString *)gender{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update gender"];
    updateGenderURL = [updateGenderURL stringByAppendingPathComponent:gender];
    
   [[NetworkManager sharedManager]getDataWithUrl:updateGenderURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
       if (statusCode ==200) {
           NSError* error;
           UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
           if (error ==nil) {
               [[NetworkManager sharedManager]setMyProfile:profile];
               [subject sendNext:@"update complete"];
           }
           else {
               [subject sendError:error];
           }
       }
       else{
           [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
       }
   }];
    return subject;
}

// 更新手机号码
-(RACSignal *)updateMobile:(CountVerifyCode *)countVerifyCode{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update email"];
    
    [[NetworkManager sharedManager]postDataWithUrl:updateMobileURL data:[countVerifyCode toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}

// 更新密码
-(RACSignal *)updatePassword:(ResetPasswordModel *)resetPasswordModel{
    
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    
    [[NetworkManager sharedManager]postDataWithUrl:updateMobileURL data:[resetPasswordModel toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
       
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}

// 更新职业
-(RACSignal *)updateOccupation:(NSString *)occupation{

    updateOccupationURL = [updateOccupationURL stringByAppendingPathComponent:occupation];
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    
    [[NetworkManager sharedManager]getDataWithUrl:updateOccupationURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}
// 更新生日
-(RACSubject *)updateBirthday:(BirthdayModel *)birthday{
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    
    [[NetworkManager sharedManager]postDataWithUrl:updateBirthday data:[birthday toJSONData] completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}

// 更新家庭地址
-(RACSignal *)updateHomeAddress:(NSString *)homeAddress{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    updateHomeAddress = [updateHomeAddress stringByAppendingPathComponent:homeAddress];
    
    [[NetworkManager sharedManager]getDataWithUrl:updateHomeAddress completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}

// 更新工作地址

-(RACSignal *)updateWorkAddress:(NSString *)workAddress{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    updateWorkAddress = [updateWorkAddress stringByAppendingPathComponent:workAddress];
    
    [[NetworkManager sharedManager]getDataWithUrl:updateWorkAddress completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}
// 验证姓名
-(RACSignal*)VerifyName:(NSString *)name{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    verifyNameURL = [verifyNameURL stringByAppendingPathComponent:name];
    
    [[NetworkManager sharedManager]getDataWithUrl:verifyNameURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            Message* message = [[Message alloc ]initWithData:data error:&error];
            if (error ==nil) {
                
                [subject sendNext:message.message];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;

}
// 更新姓名
-(RACSignal *)updateName:(NSString *)name{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"update password"];
    updateNameURL = [updateNameURL stringByAppendingPathComponent:name];
    
    [[NetworkManager sharedManager]getDataWithUrl:updateNameURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode ==200) {
            NSError* error;
            UserProfile* profile = [[UserProfile alloc ]initWithData:data error:&error];
            if (error ==nil) {
                [[NetworkManager sharedManager]setMyProfile:profile];
                [subject sendNext:@"update complete"];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
    }];
    
    return subject;
}

-(RACSignal *)getProvinces{
    
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"province"];
    [[NetworkManager sharedManager]getDataWithUrl:provinceURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
       
        if (statusCode == 200) {
            NSError* error;
            Provinces* provinces = [[Provinces alloc]initWithData:data error:&error];
            if (error ==nil) {
                [subject sendNext:provinces];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
        
    }];
    return subject;
}

-(RACSignal *)getCitiesByProvinceId:(NSInteger)provinceId{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"cities"];
    [[NetworkManager sharedManager]getDataWithUrl:cityURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode == 200) {
            NSError* error;
            Cities* cities = [[Cities alloc]initWithData:data error:&error];
            if (error ==nil) {
                [subject sendNext:cities];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
        
    }];
    return subject;

}
-(RACSignal *)getAreasByCityId:(NSInteger)cityId{

    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"cities"];
    [[NetworkManager sharedManager]getDataWithUrl:areaURL completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        
        if (statusCode == 200) {
            NSError* error;
            Areas* cities = [[Areas alloc]initWithData:data error:&error];
            if (error ==nil) {
                [subject sendNext:cities];
            }
            else {
                [subject sendError:error];
            }
        }
        else{
            [subject sendError:[NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":errorMessage}]];
        }
        
    }];
    return subject;
}



@end
