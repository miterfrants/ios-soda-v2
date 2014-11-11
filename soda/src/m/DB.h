//
//  DB.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/10.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DB : NSObject
@property FMDatabase *db;
+(DB*) getShareInstance;
+(void) setDB:(FMDatabase *)db;
+(NSString *) getSysConfig:(NSString *)key;
+(BOOL) setSysConfig:(NSString *)key value:(NSString *) value;
+(BOOL) iniSysConfig;
+(NSString *)getUI:(NSString *)key;
+(BOOL)changeLang:(NSString *) lang;
+(void)dropAllTable;
+(void)getSecretIconFromRemote:(void(^)(NSMutableDictionary *data, NSError *connectionError)) completion;
+(NSString *)getUIInnerFMDatabaseQueue:(NSString *)key;
@end
