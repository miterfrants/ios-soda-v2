//
//  UserInteractionLog.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/19.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "UserInteractionLog.h"
#import "GV.h"
#import "DB.h"
#import "FMDatabaseAdditions.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ViewTip.h"
#import "PopupView.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
@implementation UserInteractionLog
+(void)sendFuncCountWIthActionName:(NSString *)name{
    
}
+(void) sendAnalyticsEvent:(NSString *)action label:(NSString*)label{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
}
+(void) sendAnalyticsView:(NSString *)name{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:name
                                                      forKey:kGAIScreenName] build]];
}
+(void)sendUsageTimeWithStartTime:(NSDate *) sTime eTime:(NSDate *) eTime{
    GV *gv=[GV sharedInstance];
    if(gv.localUserId.length<=0){
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *sTimeStr = [formatter stringFromDate:sTime];
    NSString *eTimeStr= [formatter stringFromDate:eTime];
    NSString *accessToken=@"";
    if(gv.loginType==Facebook){
        accessToken=[FBSession activeSession].accessTokenData.accessToken;
    }else if(gv.loginType==Google){
        accessToken=gv.googleAccessToken;
    }
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&s_date=%@&e_date=%@&member_id=%@&access_token=%@",gv.urlProtocol,gv.domain,gv.controllerInteraction,gv.actionAddUsageLog,sTimeStr,eTimeStr,gv.localUserId,accessToken];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        if(connectionError || ![[data valueForKey:@"status"]isEqualToString:@"OK"]){
            [UserInteractionLog sendErrorReportWithUrl:url errMsg:[data valueForKey:@"err_msg"]];
            [self insertUsageLogToLocal:sTimeStr eDateTime:eTimeStr];
        }else{
        }
    } queue:gv.backgroundThreadManagement];
}

+(void)insertUsageLogToLocal:(NSString *)sDateTime eDateTime:(NSString *) eDateTime{
    GV *gv=[GV sharedInstance];
    NSMutableDictionary *dicPar=[[NSMutableDictionary alloc]init];
    [dicPar setValue:sDateTime forKey:@"sDateTime"];
    [dicPar setValue:eDateTime forKey:@"eDateTime"];
    //以後再來做transaction
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_insertUsageLogToLocal:) object:dicPar];
    [gv.FMDatabaseQueue addOperation:operation];
}

+(void)sendNextUsageLog{
    GV *gv=[GV sharedInstance];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_sendNextUsageLog) object:nil];
    [gv.FMDatabaseQueue addOperation:operation];
}
+(void)_sendNextUsageLog{
    FMDatabase *db=[DB getShareInstance].db;
    GV *gv=[GV sharedInstance];
    [db open];
    FMResultSet *result=[db executeQuery:[NSString stringWithFormat:@"SELECT * FROM usage_log LIMIT 1"]];
    while ([result next]) {
        NSString *strSDateTime=[result stringForColumn:@"s_date"];
        NSString *strEDateTime=[result stringForColumn:@"e_date"];
        NSString *accessToken;
        if(gv.loginType==Facebook){
            accessToken=[FBSession activeSession].accessTokenData.accessToken;
        }else if(gv.loginType==Google){
            accessToken=gv.googleAccessToken;
        }
        NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&s_date=%@&e_date=%@&member_id=%@&access_token=%@",gv.urlProtocol,gv.domain,gv.controllerInteraction,gv.actionAddUsageLog,strSDateTime,strEDateTime,gv.localUserId,accessToken];
        [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
            if(connectionError || ![[data valueForKey:@"status"]isEqualToString:@"OK"]){
                [UserInteractionLog sendErrorReportWithUrl:url errMsg:[data valueForKey:@"err_msg"]];
            }else{
                [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM usage_log WHERE id=%d",[result intForColumn:@"id"]]];
                NSLog(@"send from db:%@",data);
            }
        } queue:gv.backgroundThreadManagement];
        
    }
    [result close];
    [db close];
}

+(void)_insertUsageLogToLocal:(NSDictionary *)dicPar{
    NSString *sDateTime=[dicPar valueForKey:@"sDateTime"];
    NSString *eDateTime=[dicPar valueForKey:@"eDateTime"];
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO usage_log (s_date,e_date) VALUES ('%@','%@')",sDateTime,eDateTime]];
    [db close];
}

+(void)getAsyncProfile:(NSString *)localUserId accessToken:(NSString *)accessToken completion:(void(^)(NSMutableDictionary *data, NSError *connectionError)) completion{
    GV *gv=[GV sharedInstance];
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&member_id=%@&access_token=%@",gv.urlProtocol,gv.domain,gv.controllerInteraction,gv.actionGetUsageTime,localUserId,accessToken];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        NSLog(@"%@",url);
        if(connectionError){
            [UserInteractionLog sendErrorReportWithUrl:url errMsg:connectionError.description];
        }else{
            completion(data,connectionError);
        }
    } queue:gv.backgroundThreadManagement];
}

int usageSecondsFromDB;
+(int)getUsageSecondsFromDB{
    usageSecondsFromDB=0;
    GV *gv=[GV sharedInstance];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_getUsageSecondsFromDB) object:nil];
    [gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
    return usageSecondsFromDB;
}
+(void)_getUsageSecondsFromDB{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    usageSecondsFromDB=[db intForQuery:@"SELECT SUM((strftime('%s',e_date) - strftime('%s',s_date))) FROM usage_log"];
    [db close];
}

+(void)sendErrorReportWithUrl:(NSString *)url errMsg:(NSString *) errMsg{
    GV *gv=[GV sharedInstance];
    NSString *errUrl=[NSString stringWithFormat:@"%@://%@/%@?action=%@&url=%@&err_msg=%@&member_id=%@",gv.urlProtocol,gv.domain,gv.controllerErrorReport,gv.actionAddErrorReport,[Util urlEncode:url],[Util urlEncode:errMsg],gv.localUserId];
    [Util jsonAsyncWithUrl:errUrl target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        if(connectionError){
            NSLog(@"%@",[NSString stringWithFormat:@"UserInteraction.sendErrorReportWithUrl:%@:%@",errUrl,connectionError]);
        }else{
            NSLog(@"%@",data);
        }
    } queue:gv.backgroundThreadManagement];
}
+(void)sendLaunchLog{
    NSLog(@"%@",@"sendLaunchLog");
    GV *gv=[GV sharedInstance];
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&udid=%@",gv.urlProtocol,gv.domain,gv.controllerLaunchLog,gv.actionAddLaunchLog,[Util getUDID]];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        NSLog(@"UserInteractionLog.sendLanuchLog:finish %@" ,data);
    } queue:gv.backgroundThreadManagement];
}
+(void)showTip:(id)target titleKey:(NSString *)titleKey tipKey:(NSString *)tipKey{
    GV *gv=[GV sharedInstance];
    ViewTip *tip=(ViewTip *)gv.viewTip;
    [tip statusPreviousStatusToTip:target title:[DB getUI:titleKey] msg:[DB getUI:tipKey]];
}


@end
