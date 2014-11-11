//
//  UserInteractionLog.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/19.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
@interface UserInteractionLog : NSObject
//async
+(void)sendUsageTimeWithStartTime:(NSDate *) sDate eTime:(NSDate *) eDate;
+(void)sendFuncCountWIthActionName:(NSString *)name;
+(void)sendErrorReportWithUrl:(NSString *)url errMsg:(NSString *) errMsg;
+(void)getAsyncProfile:(NSString *)localUserId accessToken:(NSString *)accessToken completion:(void(^)(NSMutableDictionary *data, NSError *connectionError)) completion;
+(int)getUsageSecondsFromDB;
+(void)sendLaunchLog;
+(void)showTip:(id)target titleKey:(NSString *)titleKey tipKey:(NSString *)tipKey;
+(void)sendAnalyticsView:(NSString *) name;
+(void) sendAnalyticsEvent:(NSString *)action label:(NSString*)label;
@end
