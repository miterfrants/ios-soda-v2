//
//  ScrollViewProfile.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProfile.h"
#import "GV.h"
#import "Util.h"
#import "ButtonLogout.h"
#import "DB.h"
#import "UserInteractionLog.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation ViewProfile
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"profile";
        
        self.lblTitle=[[UILabel alloc] init];
        self.lblTitle.text=[DB getUI:@"profile"];
        [self.lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [self.lblTitle setTextColor:[UIColor whiteColor]];
        [self.lblTitle setFrame:CGRectMake(85, 20, 200, 40)];
        [self addSubview:self.lblTitle];
        
        self.lblName =[[UILabel alloc]initWithFrame:CGRectMake(85, 43, self.frame.size.width-85-1, 30)];
        [self.lblName setFont:self.gv.fontDescriptionForHebrew];
        [self.lblName setTextColor:[UIColor darkGrayColor]];
        [self addSubview:self.lblName];
        
        self.lblUsageTitle=[[UILabel alloc] initWithFrame:CGRectMake(15, 87.5, 130, 30)];
        [self.lblUsageTitle setTextColor:[UIColor whiteColor]];
        [self.lblUsageTitle setFont:self.gv.fontNormalForHebrew];
        [self addSubview:self.lblUsageTitle];
        self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:",[DB getUI:@"usage_time"]];
        CGSize expectedUsageSize=[self.lblUsageTitle sizeThatFits:CGSizeMake(130, 30)];
        [self.lblUsageTitle setFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.origin.y, expectedUsageSize.width, expectedUsageSize.height)];
        double padding=22;
        
        self.lblBuildedPlaceCount=[[UILabel alloc] initWithFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.origin.y+self.lblUsageTitle.frame.size.height+padding,frame.size.width-self.lblUsageTitle.frame.origin.x , self.lblUsageTitle.frame.size.height)];
        [self.lblBuildedPlaceCount setTextColor:[UIColor whiteColor]];
        [self.lblBuildedPlaceCount setFont:self.gv.fontNormalForHebrew];
        [self.lblBuildedPlaceCount setText:[NSString stringWithFormat:@"%@:",[DB getUI:@"builded_place"]]];
        [self addSubview:self.lblBuildedPlaceCount];

    }
    return self;
}
-(void) initProfile{
    [self loadProfile];
    self.lblName.text=self.gv.localUserName;
}


-(void) loadProfile{
    [self.timer invalidate];
    self.timer=nil;
    self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:",[DB getUI:@"usage_time"]];
    if(self.loadingForUsage){
        [self.loadingForUsage stop];
    }
    CGSize expectedUsageSize=[self.lblUsageTitle sizeThatFits:CGSizeMake(130, 30)];
    [self.lblUsageTitle setFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.origin.y, expectedUsageSize.width, expectedUsageSize.height)];
    self.loadingForUsage=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake(self.lblUsageTitle.frame.origin.x+self.lblUsageTitle.frame.size.width+10, self.lblUsageTitle.frame.origin.y, self.lblUsageTitle.frame.size.height, self.lblUsageTitle.frame.size.height)  thick:1];
    [self addSubview:self.loadingForUsage];
    [self.loadingForUsage start];
    NSString *accessToken=@"";
    if(self.gv.loginType==Facebook){
        accessToken=[FBSession activeSession].accessTokenData.accessToken;
    }else if(self.gv.loginType==Google){
        accessToken=self.gv.googleAccessToken;
    }
    [UserInteractionLog getAsyncProfile:self.gv.localUserId accessToken:accessToken completion:^(NSMutableDictionary *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingForUsage stop];
            self.totalSecondsFromRemote=[[[data valueForKey:@"result"] valueForKey:@"usage_time"] intValue];
            int buildedPlaceCount=[[[data valueForKey:@"result"] valueForKey:@"builded_count"] intValue];
            self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:  %@",[DB getUI:@"usage_time" ],[self calculateTimeWithSec:self.totalSecondsFromRemote]];
            CGSize expectedUsageSize=[self.lblUsageTitle sizeThatFits:CGSizeMake(self.frame.size.width-self.lblUsageTitle.frame.origin.x, 30)];
            [self.lblUsageTitle setFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.origin.y, expectedUsageSize.width, expectedUsageSize.height)];

            self.lblBuildedPlaceCount.text=[NSString stringWithFormat:@"%@:  %d",[DB getUI:@"builded_count"],buildedPlaceCount];
            CGSize expectedBuildedCount=[self.lblBuildedPlaceCount sizeThatFits:CGSizeMake(self.frame.size.width-self.lblUsageTitle.frame.origin.x, 30)];
            [self.lblBuildedPlaceCount setFrame:CGRectMake(self.lblBuildedPlaceCount.frame.origin.x, self.lblBuildedPlaceCount.frame.origin.y, expectedBuildedCount.width, expectedBuildedCount.height)];
            
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
            
            
        });
    }];
}

-(void)timerStart{
    self.gv.appExitDate=[NSDate date];
    NSTimeInterval secondsBetween = [self.gv.appExitDate timeIntervalSinceDate:self.gv.appLaunchDate];
    NSString *record=[self calculateTimeWithSec:secondsBetween+self.totalSecondsFromRemote];
    self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:  %@",[DB getUI:@"usage_time" ],record];
}
-(void)timerStop{
    [self.timer invalidate];
    self.timer =nil;
}

-(NSString *)calculateTimeWithSec:(int) secs{
    NSString *sec=[NSString stringWithFormat:@"%02d",secs%60];
    NSString *mins=[NSString stringWithFormat:@"%d",(int) floorf(secs/60)];
    NSString *min=[NSString stringWithFormat:@"%02d",[mins intValue]%60];
    NSString *hour=[NSString stringWithFormat:@"%02d",(int) floorf([mins intValue]/60)];
    return [NSString stringWithFormat:@"%@:%@:%@",hour,min,sec];
}

@end
