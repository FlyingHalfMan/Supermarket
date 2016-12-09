//
//  GFSH_HtmlParser.m
//  BookForDream
//
//  Created by gfsh on 14-3-24.
//  Copyright (c) 2014年 Gl. All rights reserved.
//

#import "GFSH_HtmlParser.h"

#import <libxml2/libxml/tree.h>
#import <libxml2/libxml/HtmlParser.h>
#import <libxml2/libxml/HTMLTree.h>

@implementation GFSH_HtmlParser
{
    xmlDoc *doc;
}

NSString * nodeAllContents(xmlNode*node);
NSString * rawContentsOfNode(xmlNode * node);

//html字符串转换为GFSH_ParagraphInfos对象
- (void)parserHtml:(NSString *)html
{
    if (html) {
        CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        CFStringRef ref = CFStringConvertEncodingToIANACharSetName(cfenc);
        const char *enc = CFStringGetCStringPtr(ref, kCFStringEncodingMacRoman);
        int parseOptions = HTML_PARSE_RECOVER;
        parseOptions = parseOptions | HTML_PARSE_NOERROR;
        parseOptions = parseOptions | HTML_PARSE_NOWARNING;
        doc = htmlReadDoc((xmlChar *)[html UTF8String], NULL, enc, parseOptions);
        if (NULL != doc) {
            [self traverseXmlNode:(xmlNode *)doc];
            xmlFreeDoc(doc);
        }
    }
}

//解析Html 将节点转换为GFSH_ParagraphInfos对象

- (void)traverseXmlNode:(xmlNode*)node
{
    for (xmlNode *fNode = node->children; NULL!= fNode; fNode = fNode->next) {
        if (NULL != fNode->name) {            
            NSString *nodeName = [NSString stringWithCString:(void *)fNode->name encoding:NSUTF8StringEncoding];
            if (fNode->type == XML_ELEMENT_NODE) {
                if(NULL != fNode->children) {
                    //body下段落换行
//                    if (NULL != fNode->parent->name) {
//                        if (strcmp((char *)fNode->parent->name,[@"body" UTF8String]) == 0 && pi.attrStrs.string.length) {
//                            [pi.attrStrs appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
//                        }
//                    }
                    
                    if ([nodeName isEqualToString:@"table"]) {
                        NSString *htmlStr = rawContentsOfNode(fNode);
                        unichar objReplaceChar = 0xFFFC;
                        NSString *str = [NSString stringWithCharacters:&objReplaceChar length:1];
                        if (htmlStr&&[self.delegate respondsToSelector:@selector(string:infos:)]) {
                            [self.delegate performSelector:@selector(string:infos:) withObject:str withObject:@[nodeName,htmlStr]];
                        }
                    }else{
                        [self traverseXmlNode:fNode];
                    }
                }else{
                    if ([nodeName isEqualToString:@"br"]) {
                        if([self.delegate respondsToSelector:@selector(string:infos:)]){
                            [self.delegate performSelector:@selector(string:infos:) withObject:@"\n" withObject:@[nodeName,@""]];
                        }
                    }
                    if ([nodeName isEqualToString:@"img"]) {
                        unichar objReplaceChar = 0xFFFC;
                        NSString *src = [self getValueForKey:@"src" fromNode:fNode];
                        NSString *str = [NSString stringWithCharacters:&objReplaceChar length:1];
                        if (src&&[self.delegate respondsToSelector:@selector(string:infos:)]) {
                            [self.delegate performSelector:@selector(string:infos:) withObject:str withObject:@[nodeName,src]];
                        }
                    }else{
                        NSString *str = nodeAllContents(fNode);
                        if (str&&[self.delegate respondsToSelector:@selector(string:infos:)]) {
                            [self.delegate performSelector:@selector(string:infos:) withObject:str withObject:@[@"text",@""]];
                        }
                    }
                }
            }else{
                if (fNode->content&&fNode->type == XML_TEXT_NODE) {
                    NSString *str = nodeAllContents(fNode);
                    if (str&&[self.delegate respondsToSelector:@selector(string:infos:)]) {
                        [self.delegate performSelector:@selector(string:infos:) withObject:str withObject:@[@"text",@""]];
                    }
                }
            }
        }
    }
}

//获取节点outerHtml

NSString * rawContentsOfNode(xmlNode * node)
{
    xmlBufferPtr buffer = xmlBufferCreateSize(1000);
    xmlOutputBufferPtr buf = xmlOutputBufferCreateBuffer(buffer, NULL);
    
    htmlNodeDumpOutput(buf, node->doc, node, (const char*)node->doc->encoding);
    
    xmlOutputBufferFlush(buf);
    
    NSString * string = nil;
    
    if (buffer->content) {
        string = [[NSString alloc] initWithBytes:(const void *)xmlBufferContent(buffer) length:xmlBufferLength(buffer) encoding:NSUTF8StringEncoding];
    }
    
    xmlOutputBufferClose(buf);
    xmlBufferFree(buffer);
    
    return string;
}

//获取元素节点的所有文本内容

NSString * nodeAllContents(xmlNode*node)
{
	if (node == NULL)
		return nil;
	
	void * contents = xmlNodeGetContent(node);
	if (contents)
    {
		NSString * string = [NSString stringWithCString:contents encoding:NSUTF8StringEncoding];
		xmlFree(contents);
		return string;
    }
	
	return @"";
}

//获取一个节点的属性数组

- (NSArray *)getAttributeNamed:(xmlNode *)node
{
    NSMutableArray *properties = [NSMutableArray array];
	for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next)
    {
        NSMutableDictionary *property = [NSMutableDictionary dictionary];
        if (attr->name) {
            NSString *propertyName = [NSString stringWithCString:(void*)attr->name encoding:NSUTF8StringEncoding];
            NSMutableArray *propertyValues = [NSMutableArray array];
            for(xmlNode * child = attr->children; NULL != child; child = child->next)
            {
                if (child->content) {
                    [propertyValues addObject:[NSString stringWithCString:(void*)child->content encoding:NSUTF8StringEncoding]];
                }
            }
            [property setObject:propertyValues forKey:propertyName];
            [properties addObject:property];
        }
    }
	
	return properties;
}

//获取一个节点下的某个属性值
- (NSString *)getValueForKey:(NSString *)key fromNode:(xmlNode *)node
{
    NSString *value = nil;
    NSArray *properties = [self getAttributeNamed:node];
    
    if (properties.count) {
        for (NSDictionary *dic in properties) {
            if (dic[key]) {
                value = dic[key][0];
                break;
            }
        }
    }
    
    return value;
}

@end
