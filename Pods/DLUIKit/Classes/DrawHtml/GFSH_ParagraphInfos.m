//
//  GFSH_ParagraphInfos.m
//  DrawPractice&Question
//
//  Created by gfsh on 14/10/29.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import "GFSH_ParagraphInfos.h"
#import "GFSH_HtmlParser.h"
#import <CoreFoundation/CoreFoundation.h>
#import <CoreText/CoreText.h>

@interface GFSH_ParagraphInfos()<GFSH_HtmlParserDelegate>
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImage *defTableImg;
@end

@implementation GFSH_ParagraphInfos

- (instancetype)init
{
    self = [super init];
    if (!self)
        return nil;
    self.attrStrs = [[NSMutableAttributedString alloc]init];
    self.tableInfos = [NSMutableArray array];
    self.imgInfos = [NSMutableArray array];
    return self;
}

- (void)parserHtml:(GFSH_BaseModel *)model atWidth:(CGFloat)width
{
    self.width = width;
    self.defTableImg = model.defaultTableImg;
    GFSH_HtmlParser *parser = [[GFSH_HtmlParser alloc]init];
    parser.delegate = self;
    [parser parserHtml:model.content];
    
    NSRange range = NSMakeRange(0, self.attrStrs.length);
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    CTParagraphStyleSetting settings[] = {
        lineBreakMode
    };
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    CFRelease(style);
    [self.attrStrs addAttributes:attributes range:range];
    NSInteger index = 0;
    while (index < range.length) {
        NSRange eRange;
        NSDictionary *attr = [self.attrStrs attribute:@"table" atIndex:index effectiveRange:&eRange];
        if (!attr) {
            [self.attrStrs addAttribute:NSFontAttributeName value:model.font range:eRange];
            [self.attrStrs addAttribute:NSForegroundColorAttributeName value:model.color range:eRange];
        }
        index = eRange.location + eRange.length;
    }
    self.size = [self computeRect:width attrString:self.attrStrs];
}

//计算一个字符的最小宽度
- (CGFloat)oneCharacterHeight
{
    NSDictionary *attr = [self.attrStrs attributesAtIndex:0 effectiveRange:nil];
    NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:@"测" attributes:attr];
    CGSize size = [self computeRect:100.f attrString:attrStr];
    return size.height;
}

//计算NSAttributedString在指定的宽度下的rect
- (CGSize)computeRect:(CGFloat)width attrString:(NSAttributedString*)attrStr
{
    CGSize size = CGSizeZero;
    if (attrStr) {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);
        size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, attrStr.length), NULL, CGSizeMake(width, CGFLOAT_MAX), NULL);
        CFRelease(framesetter);
    }
    return size;
}

- (void)string:(NSString *)str infos:(NSArray *)infos
{
    //NSString *nstr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!str.length)
        return;
    NSString *name = infos[0],*info = infos[1];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    NSRange range = NSMakeRange(0, attrStr.length);
    UIImage *img = nil;
    if ([name isEqualToString:@"table"]) {
        [mdic setObject:name forKey:@"tagName"];
        NSString *UID = [self UUID];
        [mdic setObject:UID forKey:@"ID"];
        TableInfo *ti = [[TableInfo alloc]init];
        ti.indexKey = UID;
        ti.html = info;
        [self.tableInfos addObject:ti];
        img = self.defTableImg;
        if (!img) {
            attrStr = [[NSMutableAttributedString alloc]initWithString:@" [点击查看] "];
            range = NSMakeRange(0, attrStr.length);
            [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
            [attrStr addAttribute:NSUnderlineStyleAttributeName value:@(1.5) range:NSMakeRange(1, attrStr.length-2)];
            [attrStr addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor blueColor].CGColor range:NSMakeRange(1, attrStr.length-1)];
            [attrStr addAttribute:name value:ti range:range];
        }
    }
    
    if ([name isEqualToString:@"img"]) {
        [mdic setObject:@"img" forKey:@"tagName"];
        NSString *imgName = [info lastPathComponent];
        [mdic setObject:imgName forKey:@"ID"];
        ImgInfo *ii = [[ImgInfo alloc]init];
        ii.imgName = imgName;
        ii.path = info;
        [self.imgInfos addObject:ii];
        img = [UIImage imageWithContentsOfFile:info];
    }
    if (img) {
        CGFloat ascent,descent,width;
        CGSize size = img.size;
        ascent = 0.f;
        descent = size.height;
        width = size.width;
        
        if (size.width > self.width * .5) {
            width = size.width * .05;
            descent = size.height * width / size.width;
        }
        
        [mdic setObject:@(ascent) forKey:@"ascent"];
        [mdic setObject:@(descent) forKey:@"descent"];
        [mdic setObject:@(width) forKey:@"width"];
        
        CTRunDelegateCallbacks imgCallBacks;
        imgCallBacks.version = kCTRunDelegateVersion1;
        imgCallBacks.dealloc = RunDelegateDeallocCallBack;
        imgCallBacks.getAscent = RunDelegateGetAscentCallBack;
        imgCallBacks.getDescent = RunDelegateGetDescentCallBack;
        imgCallBacks.getWidth = RunDelegateGetWithCallBack;
        
        CTRunDelegateRef run = CTRunDelegateCreate(&imgCallBacks,(__bridge_retained void *)(mdic));
        [attrStr addAttribute:(NSString*)kCTRunDelegateAttributeName value:(__bridge id)run range:range];
        CFRelease(run);
    }
    
    if (mdic.count) {
        [attrStr addAttributes:mdic range:range];
    }
    [self.attrStrs appendAttributedString:attrStr];
}

//图片信息处理的回调
void RunDelegateDeallocCallBack (void *refCon) {

}

CGFloat RunDelegateGetAscentCallBack (void *refCon){
    CGFloat ascent = 0;
    if (refCon) {
        NSDictionary *dic = (__bridge NSDictionary*)refCon;
        if (dic.count){
            ascent = [[dic objectForKey:@"ascent"]floatValue];
        }
    }
    return ascent;
}

CGFloat RunDelegateGetDescentCallBack (void *refCon){
    CGFloat descent = 0;
    if (refCon) {
        NSDictionary *dic = (__bridge NSDictionary*)refCon;
        if (dic.count){
            descent = [[dic objectForKey:@"descent"]floatValue];
        }
    }
    return descent;
}

CGFloat RunDelegateGetWithCallBack (void *refCon){
    CGFloat width = 0;
    if (refCon) {
        NSDictionary *dic = (__bridge NSDictionary*)refCon;
        if (dic.count){
            width = [[dic objectForKey:@"width"]floatValue];
        }
    }
    return width;
}

- (NSString*)UUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end

@implementation TableInfo
@end

@implementation ImgInfo
@end


