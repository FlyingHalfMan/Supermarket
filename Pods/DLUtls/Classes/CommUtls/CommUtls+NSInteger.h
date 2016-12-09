//
//  CommUtls+NSString.h
//  Pods
//
//  Created by SL on 16/1/15.
//
//

#import "CommUtls.h"

@interface CommUtls (NSInteger)

/**
 *  将num除以一个数，0舍>0入
 *
 *  @param num    除数
 *  @param divide 被除数
 *
 *  @return
 */
+ (NSInteger)numOverInt:(CGFloat)num
                 divide:(CGFloat)divide;

/**
 *  将阿拉伯数字转换为中文数字
 */
+ (NSString *)translationArabicNum:(NSInteger)arabicNum;

/**
 *  将浮点型转换成字符串，保留1位小数，去掉小数点最后的0
 *
 *  @param num     浮点
 *
 *  @return
 */
+ (NSString *)numberForString:(CGFloat)num;

@end
