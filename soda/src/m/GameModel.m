//
//  GameModel.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/7/2.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel
+(GameModel *) shareInstance{
    static GameModel *instance = nil;
    if (nil == instance) {
        instance  = [[[self class] alloc] init];
        instance.arrNotificcation=[[NSMutableArray alloc]init];
        instance.gameQueue=[[NSOperationQueue alloc] init];
        [instance.gameQueue setMaxConcurrentOperationCount:1];
        instance.audioQueue =[[NSOperationQueue alloc] init];
    }
    return instance;
}

-(void)didHoldPopup{
    [self.notificationTimer invalidate];
    self.notificationTimer=nil;
}
-(void)didFadeOut{
    NSLog(@"didFadeOut");
    GameModel *gm=[GameModel shareInstance];
    gm.notificationTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self.class selector:@selector(executeNotification:) userInfo:nil repeats:YES];
}
-(void)didFadeIn{
    [self.notificationTimer invalidate];
    self.notificationTimer=nil;
}

+(void)initialTimer:(void(^)(UIImage *icon, NSString *title, NSString *msg)) completion{
    GameModel *gm=[GameModel shareInstance];
    [gm setCompletionBlock:completion];
    gm.notificationTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(executeNotification:) userInfo:nil repeats:YES];
}




+(void)executeNotification:(id) sender{
    GameModel *gm=[GameModel shareInstance];
    if(gm.arrNotificcation.count==0){
        return;
    }
    GameNotification *currNotification=(GameNotification *)[gm.arrNotificcation objectAtIndex:0];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_executeNotification) object:nil];
    [operation setCompletionBlock:^{
        //ExecuteNotificationBlock complection=gm.notificationTimer.userInfo;
        gm.CompletionBlock(currNotification.icon,currNotification.title,currNotification.msg);
    }];
    [gm.gameQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
}

+(void)_executeNotification{
    GameModel *gm=[GameModel shareInstance];
    [gm.arrNotificcation removeObjectAtIndex:0];
}

+(void) addGameNotification:(GameNotification *)newNotification{
    GameModel *gm=[GameModel shareInstance];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self    selector:@selector(_addGameNotification:) object:newNotification];
    [gm.gameQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
    
}
+(void)_addGameNotification:(GameNotification *)newNotification{
    GameModel *gm=[self shareInstance];

    if(gm.arrNotificcation.count==0){
        [gm.arrNotificcation addObject:newNotification];
        return;
    }
//    GameNotification *lastNotification=[gm.arrNotificcation objectAtIndex:0];
//    NSTimeInterval secondsBetween = [newNotification.createdTime timeIntervalSinceDate:lastNotification.createdTime];
//    if(secondsBetween<GAME_NOTIFICATION_COMBINE_BETWEEN_SECONDS && [lastNotification.title isEqual:newNotification.title]){
//        lastNotification.msg=[lastNotification.msg stringByAppendingString:[NSString stringWithFormat:@"\r%@",newNotification.msg ]];
//        lastNotification.createdTime=newNotification.createdTime;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ExecuteNotificationBlock completion= (ExecuteNotificationBlock)gm.notificationTimer.userInfo;
//            [gm.notificationTimer invalidate];
//            gm.notificationTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(executeNotification:) userInfo:completion repeats:YES];
//        });
//    }else{
        [gm.arrNotificcation addObject:newNotification];
//    }
}


@end
