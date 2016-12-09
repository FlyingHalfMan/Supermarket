//
//  FeedBack.h
//  CdeleduUI
//
//  Created by cyx on 14-4-1.
//  Copyright (c) 2014年 Cdeledu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBack : NSObject
{
    NSString *_email;
    NSString *_phone;
    NSString *_feedContent;
}

@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *phone;
@property (nonatomic,retain) NSString *feedContent;

@end
