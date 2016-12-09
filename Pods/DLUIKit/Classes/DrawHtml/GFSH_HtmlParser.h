//
//  GFSH_HtmlParser.h
//  BookForDream
//
//  Created by gfsh on 14-3-24.
//  Copyright (c) 2014年 Gl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GFSH_HtmlParserDelegate <NSObject>

- (void)string:(NSString *)str infos:(NSArray *)infos;

@end

@interface GFSH_HtmlParser : NSObject

@property (nonatomic, assign) id delegate;

- (void)parserHtml:(NSString *)html;

@end
