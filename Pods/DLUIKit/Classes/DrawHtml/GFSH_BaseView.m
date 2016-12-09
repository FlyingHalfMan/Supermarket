//
//  GFSH_BaseView.m
//  DrawPractice&Question
//
//  Created by gfsh on 14/11/6.
//  Copyright (c) 2014年 Gao Fusheng. All rights reserved.
//

#import "GFSH_BaseView.h"
#import "GFSH_ParagraphInfos.h"
#import <CoreText/CoreText.h>

@implementation GFSH_BaseView
{
    GFSH_ParagraphInfos *paraInfos;
    GFSH_BaseModel *baseModel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    paraInfos = [[GFSH_ParagraphInfos alloc]init];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)drawWith:(GFSH_BaseModel *)model
{
    CGFloat height = 0.f;
    if (model) {
        baseModel = model;
        [paraInfos parserHtml:model atWidth:self.frame.size.width];
        height += paraInfos.size.height;
    }

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (paraInfos.attrStrs.length) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        //将画布旋转
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, 0, rect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);

//        CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)paraInfos.attrStrs);
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
//        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, paraInfos.attrStrs.length), path, NULL);
        CTFrameRef frame = [self createFrame:rect];
        CTFrameDraw(frame, context);
        [self render:frame withContext:context];
        CFRelease(frame);
    }
}

- (CTFrameRef)createFrame:(CGRect)rect
{
    CTFramesetterRef framesetter =  CTFramesetterCreateWithAttributedString((CFAttributedStringRef)paraInfos.attrStrs);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, paraInfos.attrStrs.length), path, NULL);
    CFRelease(path);
    CFRelease(framesetter);
    return frame;
}

- (void)render:(CTFrameRef)frame withContext:(CGContextRef)context
{
    CFArrayRef lines = CTFrameGetLines(frame);
    //获取每行的原点坐标
    CGPoint lineOrigins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < CFArrayGetCount(lines); i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
//        CGFloat lineAscent,lineDescent,lineLeading;
//        //获取每行的宽度和高度
//        CGFloat lineWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
//        CGFloat oneLineHeight = lineAscent + lineDescent;// + lineLeading;
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CGPoint lineOrigin = lineOrigins[i];
        for (int j = 0; j < CFArrayGetCount(runs); j++) {
            //获取每个CTRun
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            
            CFRange range = CTRunGetStringRange(run);
            
            CGFloat offset = CTLineGetOffsetForStringIndex(line, range.location, NULL);
            
            NSDictionary* attributes = (NSDictionary*)CTRunGetAttributes(run);
            NSString *tagName = [attributes objectForKey:@"tagName"];
            NSString *ID = [attributes objectForKey:@"ID"];
            
            CGFloat ascent = [[attributes objectForKey:@"ascent"]floatValue];
            CGFloat descent = [[attributes objectForKey:@"descent"]floatValue];
            CGFloat width = [[attributes objectForKey:@"width"]floatValue];
            if ([tagName isEqualToString:@"img"]) {
                NSString *filePath = nil;
                ImgInfo *currentII = nil;
                for (ImgInfo *ii in paraInfos.imgInfos) {
                    if ([ii.imgName isEqualToString:ID]) {
                        filePath = ii.path;
                        currentII = ii;
                        break;
                    }
                }
                UIImage *img = [UIImage imageWithContentsOfFile:filePath];
                if (img) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(width,ascent + descent);
                    imageDrawRect.origin.x = lineOrigin.x+offset;
                    imageDrawRect.origin.y = lineOrigin.y-ascent-descent/*+oneLineHeight-ascent-descent*/;
                    CGContextDrawImage(context, imageDrawRect, img.CGImage);
                    if (currentII) {
                        currentII.rect = CGRectMake(imageDrawRect.origin.x, self.frame.size.height-lineOrigin.y, imageDrawRect.size.width, imageDrawRect.size.height);;
                    }
                }
            }
            if ([tagName isEqualToString:@"table"]) {
                //NSString *html = nil;
                TableInfo *currentTI = nil;
                for (TableInfo *ti in paraInfos.tableInfos) {
                    if ([ti.indexKey isEqualToString:ID]) {
                        //html = ti.html;
                        currentTI = ti;
                        break;
                    }
                }
                UIImage *img = baseModel.defaultTableImg;
                if (img) {
                    CGRect imageDrawRect;
                    imageDrawRect.size = CGSizeMake(width,ascent + descent);
                    imageDrawRect.origin.x = lineOrigin.x+offset;
                    imageDrawRect.origin.y = lineOrigin.y-ascent-descent/*+oneLineHeight-ascent-descent*/;
                    CGContextDrawImage(context, imageDrawRect, img.CGImage);
                    if (currentTI) {
                        currentTI.rect = CGRectMake(imageDrawRect.origin.x, self.frame.size.height-lineOrigin.y, imageDrawRect.size.width, imageDrawRect.size.height);
                    }
                }
            }
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint p = [touch locationInView:self];
    ImgInfo *touchII = nil;
    TableInfo *touchTI = nil;
    for (ImgInfo *ii in paraInfos.imgInfos) {
        if (CGRectContainsPoint(ii.rect, p)) {
            touchII = ii;
            break;
        }
    }
    
    for (TableInfo *ti in paraInfos.tableInfos) {
        if (CGRectContainsPoint(ti.rect, p)) {
            touchTI = ti;
            break;
        }
    }
    
    if (!(touchII&&touchTI)) {
        CTFrameRef frame = [self createFrame:self.bounds];
        CGFloat height;
        CFIndex index;
        CFRange range;
        CGPoint lineOrigin;
        CTLineRef sline = getLineContainPoint(p, frame, self.frame, &height, &index, &range, &lineOrigin);
        if (sline) {
            CFArrayRef runs = CTLineGetGlyphRuns(sline);
            for (int j = 0; j < CFArrayGetCount(runs); j++) {
                //获取每个CTRun
                CTRunRef run = CFArrayGetValueAtIndex(runs, j);
                NSDictionary* attrDic = (NSDictionary*)CTRunGetAttributes(run);
                TableInfo *ti = attrDic[@"table"];
                if (ti) {
                    touchTI = ti;
                }
            }
        }
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIControl *bg = [[UIControl alloc]initWithFrame:window.bounds];
    bg.backgroundColor = [UIColor grayColor];
    bg.tag = 100;
    [bg addTarget:self action:@selector(removeTouchShow) forControlEvents:UIControlEventTouchDown];
    if (touchII) {
        [window addSubview:bg];
        UIImage *img = [UIImage imageWithContentsOfFile:touchII.path];
        UIImageView *iv = [[UIImageView alloc]initWithImage:img];
        iv.center = window.center;
        [bg addSubview:iv];
    }
    
    if (touchTI) {
        [window addSubview:bg];
        UIWebView *wv = [[UIWebView alloc]initWithFrame:window.bounds];
        wv.center = window.center;
        wv.backgroundColor = [UIColor clearColor];
        [wv loadHTMLString:[NSString stringWithFormat:@"<br/>%@",touchTI.html] baseURL:nil];
        [bg addSubview:wv];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTouchShow)];
        [wv addGestureRecognizer:tap];
        for (UIGestureRecognizer *gr in wv.gestureRecognizers) {
            gr.delegate = self;
        }
    }
    
}

CTLineRef getLineContainPoint(CGPoint p,CTFrameRef frame,CGRect rect,CGFloat *height,CFIndex *index,CFRange *range,CGPoint *lineOrigin)
{
    CTLineRef line = NULL;
    CFArrayRef lines = CTFrameGetLines(frame);
    CGPoint origins[CFArrayGetCount(lines)];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), origins);
    for (int j= 0; j < CFArrayGetCount(lines); j++) {
        CGPoint origin = origins[j];
        CGFloat y = rect.origin.y + rect.size.height - origin.y;
        //判断点击的位置处于那一行范围内
        if ((p.y <= y) && (p.x >= rect.origin.x && p.x <rect.origin.x+rect.size.width)) {
            CGFloat lineAscent;
            CGFloat lineDescent;
            CGFloat lineLeading;
            //获取行
            line = CFArrayGetValueAtIndex(lines, j);
            //获取行的起始点坐标
            *lineOrigin = origin;
            //获取行的宽度和高度
            CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
            *height = lineAscent+lineDescent+lineLeading;
            //获取点击位置所处的字符位置，就是相当于点击了第几个字符
            p.x -= origin.x + rect.origin.x;
            (*index) = CTLineGetStringIndexForPosition(line, p);
            //获取行内字符串的在整个paragraphInfo的pContent中的位置
            *range = CTLineGetStringRange(line);
            break;
        }
    }
    return line;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]&&[otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        [self removeTouchShow];
        return NO;
    }
    return YES;
}

- (void)removeTouchShow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *touchView = [window viewWithTag:100];
    [touchView removeFromSuperview];
}


@end
