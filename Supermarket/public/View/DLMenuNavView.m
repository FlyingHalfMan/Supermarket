//
//  DLMenuNavView.m
//  WXTest
//
//  Created by SL on 15/1/4.
//  Copyright (c) 2015年 Sheng Long. All rights reserved.
//

#import "DLMenuNavView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "CommUtls.h"

#define SELECTED_X_START                50

#define BUTTON_GAP                      0
#define BUTTON_TXT_GAP                  15
//#define BUTTON_TXT_FONT                 18

#define BUTTON_TRUE_TAG(__num)          (__num-49128)
#define BUTTON_TAG(__num)               (__num+49128)

typedef void (^IndexLocBlock)(NSInteger index);

@interface DLMenuNavView ()

/**
 *  菜单
 */
@property (nonatomic,strong) NSArray *menuNames;

/**
 *  默认字体
 */
@property (nonatomic,strong) UIFont *textFont;

/**
 *  默认颜色
 */
@property (nonatomic,strong) UIColor *normalTextColor;
@property (nonatomic,strong) NSArray *normalColor;

/**
 *  选中颜色
 */
@property (nonatomic,strong) UIColor *selectedTextColor;
@property (nonatomic,strong) NSArray *highlightedColor;

/**
 *  位置block
 */
@property (nonatomic,copy) IndexLocBlock locBlock;

/**
 *  菜单显示
 */
@property (nonatomic,strong) UIScrollView *scrollView;

/**
 *  当前选中位置
 */
@property (nonatomic,assign) NSInteger selectIndex;

/**
 *  下面选中标识view
 */
@property (nonatomic,strong) UIView *selectView;

/**
 *  滑动所需，scrollViewDidScroll方法
 */
@property (nonatomic,assign) CGFloat startLoc;
@property (nonatomic,assign) CGFloat startSelectLoc;
@property (nonatomic,assign) CGFloat selectWidth;

@end

@implementation DLMenuNavView

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

- (instancetype)initWithFrame:(CGRect)frame
                    menuNames:(NSArray *)menuNames
                  normalColor:(UIColor *)normalColor
                selectedColor:(UIColor *)selectedColor
                         font:(UIFont *)font
                      showLoc:(void(^)(NSInteger index))showLoc {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalTextColor = normalColor;
        self.normalColor = [self getSelectedColor:[self changeUIColorToRGB:normalColor]];
        self.selectedTextColor = selectedColor;
        self.highlightedColor = [self getSelectedColor:[self changeUIColorToRGB:selectedColor]];
        self.textFont = font;
        self.locBlock = showLoc;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(BUTTON_GAP, 0, self.frame.size.width-BUTTON_GAP*2, self.frame.size.height)];
        self.scrollView = scrollView;
        scrollView.scrollsToTop = NO;
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [self addSubview:scrollView];
        
        [self reloadData:menuNames];
        
        CGFloat height = 2./[UIScreen mainScreen].scale;
        UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height-height, CGFLOAT_MIN, height)];
        [scrollView addSubview:selectView];
        selectView.backgroundColor = self.selectedTextColor;
        self.selectView = selectView;
    }
    return self;
}

- (void)reloadData:(NSArray *)menuNames {
    self.menuNames = menuNames;

    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.selectView]) {
            [obj removeFromSuperview];
        }
    }];
    
    __block CGFloat xStart = 0;
    [self.menuNames enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:obj forState:UIControlStateNormal];
        [button.titleLabel setFont:self.textFont];
        [button setTag:BUTTON_TAG(idx)];
        [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
        [button sizeToFit];
        [button setFrame:CGRectMake(xStart, 0, button.frame.size.width+BUTTON_TXT_GAP*2, self.scrollView.frame.size.height)];
        [self.scrollView addSubview:button];
        [button addTarget:self action:@selector(clickButt:) forControlEvents:UIControlEventTouchUpInside];
        xStart+=(button.frame.size.width+BUTTON_GAP);
    }];
    [self.scrollView setContentSize:CGSizeMake(xStart, 0)];
}

/**
 *  点击菜单
 */
- (void)clickButt:(UIButton *)button {
    [self setSelected:BUTTON_TRUE_TAG(button.tag) animated:YES];
}

- (void)setSelected:(NSInteger)index animated:(BOOL)animated {
    //容错
    if (index >= self.menuNames.count || index < 0) {
        index = 0;
    }
    
    if (self.locBlock) {
        self.locBlock(index);
    }
    
    UIButton *button = [self.scrollView viewWithTag:BUTTON_TAG(self.selectIndex)];
    [button setTitleColor:self.normalTextColor forState:UIControlStateNormal];
    
    self.selectIndex = index;
    UIButton *button1 = [self.scrollView viewWithTag:BUTTON_TAG(self.selectIndex)];
    [button1 setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
    
    self.selectView.frame = CGRectMake(button1.frame.origin.x+BUTTON_TXT_GAP, self.selectView.frame.origin.y, button1.frame.size.width-BUTTON_TXT_GAP*2, self.selectView.frame.size.height);
    
    [self currentLoc:index animated:animated];
}

/**
 *  变换菜单显示位置
 */
- (void)currentLoc:(NSInteger)index animated:(BOOL)animated {
    CGFloat endLoc = [self fetchScrollViewLoc:index];
    [self.scrollView setContentOffset:CGPointMake(endLoc, 0) animated:animated];

    if (!animated) {
        self.startLoc = self.scrollView.contentOffset.x;
        self.startSelectLoc = self.selectView.frame.origin.x;
        self.selectWidth = self.selectView.frame.size.width;
    }
}

- (void)moveLoc:(CGFloat)gap movingLoc:(CGFloat)movingLoc {
    if (gap*self.selectIndex > movingLoc) {
        //上一页
        if (self.selectIndex > 0) {
            NSInteger index = movingLoc/gap;
            if (index >= 0 && index < self.selectIndex) {
                
                if (self.selectIndex - index > 1 || movingLoc == 0) {
                    [self setSelected:self.selectIndex - 1 animated:NO];
                    return;
                }
                
                CGFloat bfb = (gap*self.selectIndex-movingLoc)*1./(gap*(self.selectIndex-index));
                
                CGFloat endLoc = [self fetchScrollViewLoc:index];
                if (self.scrollView.contentOffset.x > endLoc) {
                    [self.scrollView setContentOffset:CGPointMake(self.startLoc-(self.startLoc - endLoc)*bfb, 0) animated:NO];
                }
                
                UIButton *button = [self.scrollView viewWithTag:BUTTON_TAG(index)];
                endLoc = button.frame.origin.x+BUTTON_TXT_GAP;
                self.selectView.frame = CGRectMake(self.startSelectLoc-(self.startSelectLoc - endLoc)*bfb, self.selectView.frame.origin.y, self.selectWidth-(self.selectWidth - (button.frame.size.width-BUTTON_TXT_GAP*2))*bfb, self.selectView.frame.size.height);
                
                [self changeButtonShowState:bfb button:button];
                [self changeButtonShowState:1-bfb button:[self.scrollView viewWithTag:BUTTON_TAG(self.selectIndex)]];
            }
        }
    }else{
        //下一页
        if (self.selectIndex < self.menuNames.count-1) {
            NSInteger index = [self numOverInt:movingLoc divide:gap];
            if (index <= self.menuNames.count-1 && index > self.selectIndex) {
                
                if (index - self.selectIndex > 1 || index*gap == movingLoc) {
                    [self setSelected:self.selectIndex+1 animated:NO];
                    return;
                }
                
                CGFloat bfb = (movingLoc-gap*self.selectIndex)*1./(gap*(index-self.selectIndex));
                
                CGFloat endLoc = [self fetchScrollViewLoc:index];
                if (self.scrollView.contentOffset.x < endLoc) {
                    [self.scrollView setContentOffset:CGPointMake(self.startLoc+(endLoc - self.startLoc)*bfb, 0) animated:NO];
                }
                
                UIButton *button = [self.scrollView viewWithTag:BUTTON_TAG(index)];
                endLoc = button.frame.origin.x+BUTTON_TXT_GAP;
                self.selectView.frame = CGRectMake(self.startSelectLoc+(endLoc - self.startSelectLoc)*bfb, self.selectView.frame.origin.y, self.selectWidth-(self.selectWidth - (button.frame.size.width-BUTTON_TXT_GAP*2))*bfb, self.selectView.frame.size.height);
                
                [self changeButtonShowState:1-bfb button:[self.scrollView viewWithTag:BUTTON_TAG(self.selectIndex)]];
                [self changeButtonShowState:bfb button:button];
            }
        }
    }
}

/**
 *  获取scrollView移动的位置
 */
- (CGFloat)fetchScrollViewLoc:(NSInteger)index {
    CGFloat endLoc = 0;
    UIButton *button = [self.scrollView viewWithTag:BUTTON_TAG(index)];
    CGFloat xLoc = button.frame.origin.x;
    if (self.scrollView.contentSize.width>self.scrollView.frame.size.width) {
        if (xLoc<SELECTED_X_START) {
            endLoc = 0;
        }else if((xLoc+(self.scrollView.frame.size.width-SELECTED_X_START))>self.scrollView.contentSize.width){
            endLoc = self.scrollView.contentSize.width-self.scrollView.frame.size.width;
        }else{
            endLoc = xLoc-SELECTED_X_START;
        }
    }
    return endLoc;
}

/**
 *  将num除以一个数，0舍>0入
 *
 *  @param num    除数
 *  @param divide 被除数
 *
 *  @return
 */
- (NSInteger)numOverInt:(CGFloat)num
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

#pragma mark - button字体颜色变化
/**
 *  改变UIButton的颜色状态
 *
 *  @param percent <#percent description#>
 *  @param button  <#button description#>
 */
- (void)changeButtonShowState:(CGFloat)percent button:(UIButton *)button {
//    float value = [self lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:value]];
    [self changeColorForButton:button red:percent];
}

//变化颜色
- (void)changeColorForButton:(UIButton *)button red:(float)nRedPercent {
    //  180    180     180
    //  31     158     255
    //    float value1 = [self lerp:1-nRedPercent min:31 max:180];
    //    float value2 = [self lerp:1-nRedPercent min:158 max:180];
    //    float value3 = [self lerp:nRedPercent min:180 max:255];
    //    [button setTitleColor:[UIColor colorWithRed:value1/255.0 green:value2/255.0 blue:value3/255.0 alpha:1] forState:UIControlStateNormal];
    
    if (nRedPercent >= 0 && nRedPercent <= 1) {
        NSMutableArray *array = [NSMutableArray new];
        [self.normalColor enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat min = MIN([self.normalColor[idx] floatValue], [self.highlightedColor[idx] floatValue]);
            CGFloat max = MAX([self.normalColor[idx] floatValue], [self.highlightedColor[idx] floatValue]);
            float value = [self lerp:(([self.normalColor[idx] floatValue] > [self.highlightedColor[idx] floatValue])?1-nRedPercent:nRedPercent) min:min max:max];
            [array addObject:[NSNumber numberWithFloat:value]];
        }];
        [button setTitleColor:[UIColor colorWithRed:[array[0] floatValue]/255.0 green:[array[1] floatValue]/255.0 blue:[array[2] floatValue]/255.0 alpha:1] forState:UIControlStateNormal];
    }
}

/**
 *  获取随机值
 *
 *  @param percent <#percent description#>
 *  @param nMin    <#nMin description#>
 *  @param nMax    <#nMax description#>
 *
 *  @return <#return value description#>
 */
- (float)lerp:(float)percent min:(float)nMin max:(float)nMax {
    float result = nMin;
    result = nMin + percent * (nMax - nMin);
    return result;
}

- (NSString *)changeUIColorToRGB:(UIColor *)color{
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    NSString *r = [NSString stringWithFormat:@"%@",[self ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

/**
 *  十进制转十六进制
 *
 *  @param tmpid <#tmpid description#>
 *
 *  @return <#return value description#>
 */
- (NSString *)ToHex:(int)tmpid {
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig) {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
    }
    switch (tmp) {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

- (NSArray *)getSelectedColor:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return @[@"255",@"255",@"255"];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    else if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return @[@"255",@"255",@"255"];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return @[
             [NSNumber numberWithUnsignedInt:r],
             [NSNumber numberWithUnsignedInt:g],
             [NSNumber numberWithUnsignedInt:b],
             ];
}

@end
