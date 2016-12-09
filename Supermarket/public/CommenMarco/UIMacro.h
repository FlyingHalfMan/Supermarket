//
//  UIMacro.h
//  MobileClassPhone
//
//  Created by cyx on 14/12/2.
//  Copyright (c) 2014年 cyx. All rights reserved.
//

#ifndef MobileClassPhone_UIMacro_h
#define MobileClassPhone_UIMacro_h

// 字体
#define MAX_LARGE_FONT_SIZE     20

#define LARGE_FONT_SIZE         18

#define MIDDLE_FONT_SIZE        16

#define SMALL_FONT_SIZE         13

#define MIN_FONT_SIZE           11

/** 程序主色调 */
#define APP_MainColor           @"#FF4500"

// 默认TableViewCell高度
#define kDefaultCellHeight 50
// 默认界面之间的间距
#define kDefaultMargin     8
// 默认的字体颜色
#define kMainTextColor                kBlackColor

#define kDetailTextColor              RGB(145, 145, 145)

/** 导航栏高度 */
#define NAVIGATIONBAR_HEIGHT (IsIOS7 ? 65 : 45)
/** 分栏高度 */
#define TABLE_BAR_HEIGHT   49
// 屏幕宽高
#define kMainScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kMainScreenHeight   [[UIScreen mainScreen] bounds].size.height

#endif
