//
//  CommUtls+NSString.m
//  Pods
//
//  Created by SL on 16/1/15.
//
//

#import "CommUtls+NSInteger.h"

@implementation CommUtls (NSInteger)

+ (NSInteger)numOverInt:(CGFloat)num
                 divide:(CGFloat)divide{
    if (divide!=0) {
        CGFloat v1 = (CGFloat)(num*1./divide);
        NSInteger v2 = (NSInteger)(num/divide);
        if (v1>v2) {
            return v2+1;
        }
        return v2;
    }
    return num;
}

+ (NSString *)translationArabicNum:(NSInteger)arabicNum{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

+ (NSString *)numberForString:(CGFloat)num{
    NSString *txt = [NSString stringWithFormat:@"%.1f",num];

    NSArray *array = [txt componentsSeparatedByString:@"."];
    if (array.count==2) {
        //后面一位小数如果转成整形肯定为0
        NSInteger last = [array.lastObject integerValue];
        if (last>0) {
            return [NSString stringWithFormat:@"%@.%ld",array.firstObject,(long)last];
        }else{
            return array.firstObject;
        }
    }
    
    return txt;
}

@end
