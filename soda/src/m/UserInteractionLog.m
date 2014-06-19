//
//  UserInteractionLog.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/19.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "UserInteractionLog.h"
#import "Util.h"
#import "GV.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation UserInteractionLog
+(void)sendFuncCountWIthActionName:(NSString *)name{
    
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
    NSLog(@"%@",url);
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        if(connectionError){
            [UserInteractionLog sendUsageTimeWithStartTime:sTime eTime:eTime];
        }else{
            if(![[data valueForKey:@"status"]isEqualToString:@"OK"]){
                [UserInteractionLog sendErrorReportWithUrl:url errMsg:[data valueForKey:@"err_msg"]];
            }else{
                NSLog(@"%@",data);
            }
        }
    } queue:gv.backgroundThreadManagement];
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
@end
