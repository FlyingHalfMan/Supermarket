//
//  DLMacro.h
//  DL
//
//  Created by cyx on 14-9-16.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#ifndef DL_DLMacro_h
#define DL_DLMacro_h

// 公共工具类
#import <DLUtls/CommUtls.h>
// 网络助手
#import <DLUtls/NetStatusHelper.h>
// 开发框架
#import <BaseWithRAC/BaseMacro.h>



#define AppErrorMsgKey              @"errorInfo"
#define AppErrorMsg                 @"获取数据失败"
#define AppNetErrorMsg              @"数据错误"

#define AppErrorParsing(__error)    \
({  \
NSString *title = nil;   \
if ([__error isKindOfClass:[NSError class]]) {  \
if ([__error.domain isEqualToString:CustomErrorDomain]) {     \
title = __error.userInfo[AppErrorMsgKey];   \
}   \
if(!title.length){  \
if(__error.code == DLNoNet && __error.userInfo[NSLocalizedDescriptionKey]) {  \
title = NO_NET_STATIC_SHOW;    \
}   \
}   \
}   \
if(!title.length){  \
title = AppErrorMsg;    \
}   \
title;  \
})

#define AppErrorSetting(__errorName)    \
({  \
NSString *title = AppErrorMsg;   \
if(__errorName){\
title = __errorName;\
}\
[NSError errorWithDomain:CustomErrorDomain code:DLDataFailed userInfo:@{AppErrorMsgKey:title}];\
})

//未付费用户默认UID
#define NO_PAY_UID   -1

#endif
