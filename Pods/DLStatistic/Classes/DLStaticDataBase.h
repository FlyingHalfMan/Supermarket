//
//  DLStaticDataBase.h
//  Pods
//
//  Created by cdeledu on 14-11-27.
//
//

#import <Foundation/Foundation.h>

@interface DLStaticDataBase : NSObject

+ (DLStaticDataBase *)defaultStaticDB;

- (void)closeDataBase;

//// Static
- (BOOL)addOneStaticWithTime:(NSString *)time
                     version:(NSString *)version
                     network:(NSString *)network
                  operatorer:(NSString *)operatorer;
- (void)judgeToRemoveStaticOfOutOfTime;
- (NSMutableDictionary *)achiveAllStatics;
- (BOOL)resetTableOfStatics;

@end
