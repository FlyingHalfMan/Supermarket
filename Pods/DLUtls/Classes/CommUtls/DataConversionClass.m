//
//  DataConversionClass.m
//  ContinueEDUPhone
//
//  Created by SL on 13-11-27.
//  Copyright (c) 2013年 Sheng Long. All rights reserved.
//

#import "DataConversionClass.h"
#import <JSONKit-NoWarning/JSONKit.h>

//解析对应的Key
#define DataConversionClassKey      @"asdfqrekjhxgui127900lopbuhg612"


@interface DataConversionClass()<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    
    //
    NSMutableString *textInProgress;
}

//保持的NSMutableDictionary和NSString   方便转换
@property (nonatomic,retain) NSMutableDictionary *keepDic;
@property (nonatomic,retain) NSString *keepStr;

//节点为数组的节点名称
@property (nonatomic,retain) NSArray *nodeArrayName;

@end

@implementation DataConversionClass

@synthesize keepDic,keepStr,nodeArrayName;



+ (instancetype)sharedManager
{
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

/**
 *  XML Data 转换成字典
 *
 *  @param data  XML Data
 *  @param array 已知XML字段为数组的节点名称，以免该节点只有一条信息时候返回非数组数据
 *
 *  @return 字典对象
 */
+(NSDictionary*)XMLDataToDic:(NSData*)data arrayName:(NSArray*)array
{
    return [[self sharedManager] XMLDataToDic:data arrayName:array];
}

//XML转换成字典
-(NSDictionary*)XMLDataToDic:(NSData*)data arrayName:(NSArray*)array
{
    if (!dictionaryStack) {
        dictionaryStack = [[NSMutableArray alloc] init];
    }
    [dictionaryStack removeAllObjects];
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    textInProgress = [[NSMutableString alloc] init];
    
    //节点为数组的节点名称
    if (array.count) {
        self.nodeArrayName = [@[@""] arrayByAddingObjectsFromArray:array];
    }
    
    //开始解析
    NSXMLParser *xmlpaser = [[NSXMLParser alloc] initWithData:data] ;
    [xmlpaser setDelegate:self];
    BOOL success = [xmlpaser parse];
    if (success) {
        NSDictionary *resultDict = [dictionaryStack objectAtIndex:0];
        //转换key值
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:resultDict];
        [self changeKeyFromDic:dic nsarray:nil];
//        NSLog(@"XML转字典开始==%@==XML转字典OK",[dic JSONString]);
        //重置保持的对象
        self.keepDic = nil;
        self.keepStr = nil;
        self.nodeArrayName = nil;
#ifdef DEBUG
        NSLog(@"XML转JSON==%@",[dic JSONString]);
#endif
        return dic;
    }
    return nil;
}

#pragma mark - 改变key值
/**
 *  将XML最后的值的KEY值 DataConversionClassKey 给转换掉
 *
 *  @param dataDic 字典格式的数据
 *  @param nsarray 上层是否为数组格式，默认穿nil，有就传入数组数据
 */
-(void)changeKeyFromDic:(NSMutableDictionary*)dataDic nsarray:(NSMutableArray*)nsarray
{
    if ([[dataDic allKeys] count]==0) {
        if (nsarray) {
            //数组直接替换空值
            [nsarray replaceObjectAtIndex:[nsarray indexOfObject:dataDic] withObject:@""];
        }else{
            //当前字典为空时，设置当前值为空
            [keepDic setValue:@"" forKey:keepStr];
        }
    }else{
        for (NSString *str in [dataDic allKeys]) {
            if ([str isEqualToString:DataConversionClassKey]) {
                
                if (nsarray) {
                    //上层是数组数据就替换数据源
                    [nsarray replaceObjectAtIndex:[nsarray indexOfObject:dataDic] withObject:[dataDic valueForKey:DataConversionClassKey]];
                }else{
                    //否则改变Value值
                    [keepDic setValue:[dataDic valueForKey:DataConversionClassKey] forKey:keepStr];
                }
                self.keepDic = nil;
                self.keepStr = nil;
                
            }else{
                
                NSObject *o = [dataDic objectForKey:str];
                
                //判断当前节点是否为数组
                if ([nodeArrayName containsObject:str]) {
                    //替换成数组格式
                    if (keepDic && !nsarray && [keepDic[keepStr] isKindOfClass:[NSDictionary class]]) {
                        [keepDic[keepStr] setObject:[self dicToArr:o] forKey:str];
                    }else{
                        //上层是数组数据就替换数据源
                        [dataDic setObject:[self dicToArr:o] forKey:str];
                    }
                    o = [dataDic objectForKey:str];
                }
                
                if ([o isKindOfClass:[NSArray class]]) {
                    //数组
                    [self changeKeyFromArray:(NSMutableArray*)o];
                }else if ([o isKindOfClass:[NSDictionary class]]){
                    //记录此节点数据
                    self.keepDic = dataDic;
                    self.keepStr = str;
                    [self changeKeyFromDic:(NSMutableDictionary*)o nsarray:nil];
                }
            }
        }
    }
}

/**
 *  遍历XML数据中为数组的数据源
 *
 *  @param dataArray
 */
-(void)changeKeyFromArray:(NSMutableArray*)dataArray
{
    NSArray *array = [NSArray arrayWithArray:dataArray];
    
    for (NSObject *o in array) {
        if ([o isKindOfClass:[NSArray class]]) {
            //数组
            [self changeKeyFromArray:(NSMutableArray*)o];
        }else if ([o isKindOfClass:[NSDictionary class]]){
            [self changeKeyFromDic:(NSMutableDictionary*)o nsarray:dataArray];
        }
    }
}

/**
 *  当数组个数为1时，xml直接解成字典，需要执行此方法，返回一个数组格式的数据
 *
 *  @param ob
 *
 *  @return
 */
-(NSMutableArray*)dicToArr:(id)ob
{
    if ([ob isKindOfClass:[NSDictionary class]]) {
        NSMutableArray *array = [NSMutableArray arrayWithObject:ob];
        return array;
    }
    return ob;
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there's already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn't exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    // Set the text property
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:DataConversionClassKey];
        
        // Reset the text
        textInProgress = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //去掉两头空格
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length>0) {
        //添加节点的值
        [textInProgress appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser's error object
    NSLog(@"XML解析错误===%@==",parseError);
}

@end
