//
//  LMUSearchHistoryViewClient.m
//  Supermarket
//
//  Created by DL on 2016/11/27.
//  Copyright © 2016年 cn.programingmokey. All rights reserved.
//

#import "LMUSearchHistoryViewClient.h"
#import "LMUSearcHistoryModel.h"
@implementation LMUSearchHistoryViewClient

-(RACSignal*)loadData{
    RACSubject* subject = [[RACSubject subject]setNameWithFormat:@"search history"];
    NSArray* historyArray = [[NSArray alloc]init];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    historyArray = [defaults valueForKey:@"searchHistory"];
    if (historyArray ==nil || historyArray.count <1) {
        NSError*error = [NSError errorWithDomain:CustomErrorDomain code:404 userInfo:@{@"error":@"没有搜索记录"}];
        [subject sendError:error];
    }
    else {
        [subject sendNext:[self sortByDate:historyArray]];
    }
    return subject ;
}

-(NSArray<LMUSearcHistoryModel*>*)sortByDate:(NSArray*)array{
    NSArray<LMUSearcHistoryModel*>*resultArray = [[NSArray alloc]init];;
    for (NSDictionary* dir in array) {
        NSError* error;
        LMUSearcHistoryModel* model = [[LMUSearcHistoryModel alloc]initWithDictionary:dir error:&error];
        if (error ==nil) {
            [resultArray arrayByAddingObject:model];
        }
        else {
          NSLog(@"数据解析错误 %@",error);
            return nil;
        }
    }
    for(int i=0;i<resultArray.count-1;i++){
        LMUSearcHistoryModel* model1 = resultArray[i];
        LMUSearcHistoryModel* model2 = resultArray[i+1];
        if (model1.date < model2.date) {
            LMUSearcHistoryModel* tmpModel =[[LMUSearcHistoryModel alloc]init];
            tmpModel =model1;
            model1 = model2;
            model2 =tmpModel;
        }
    }
    return resultArray;
}

-(RACSignal *)searchWithText:(NSString *)text andType:(NSInteger)type{
    
    // 先将搜索记录写入到本地nsuserdefaults 中
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    LMUSearcHistoryModel* model =[[LMUSearcHistoryModel alloc]initWithText:text];
    NSArray* historyArray = [defaults valueForKey:@"searchHistory"];
    [historyArray arrayByAddingObject:model];

    [defaults setValue:historyArray forKey:@"searchHistory"];
    
    // 向网络发送一个查询请求
    RACSubject* subject =[[ RACSubject subject]setNameWithFormat:@"search complete"];
    NSString* url =[NSString stringWithFormat:@"search?content=%@?type=%ld",text,type];
    [[NetworkManager sharedManager]getDataWithUrl:url completionHandler:^(long statusCode, NSData *data, NSString *errorMessage) {
        // 根据网络回来的结果
        if (statusCode ==200) {
            NSError* error;
            SearchResults* searchResults = [[SearchResults alloc]initWithData:data error:&error];
            if (error ==nil) {
                  [subject sendNext:searchResults.results];
            }
            else{
               [subject sendError:nil];
            }
            NSLog(@"data");
        }else{
            [subject sendError:nil];
        }

    }];
    return subject;
}

@end
