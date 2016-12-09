//
//  DLLoadingSetting.m
//  Pods
//
//  Created by SL on 16/3/1.
//
//

#import "DLLoadingSetting.h"
#import <DLUtls/CommUtls.h>

@interface DLLoadingSetting ()

@end

@implementation DLLoadingSetting

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"dealloc -- %@",self.class);
#endif
}

+ (instancetype)sharedInstance {
    static DLLoadingSetting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DLLoadingSetting alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.loadingColor = [CommUtls colorWithHexString:@"#0099ff"];
        self.lineWidth = 1.5;
        self.loadingStart = 45;
    }
    return self;
}

@end
