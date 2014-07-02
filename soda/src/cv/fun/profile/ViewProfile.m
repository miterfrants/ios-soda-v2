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
#import "ViewControllerRoot.h"

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
        [self.lblTitle setFrame:CGRectMake(68, 20, 200, 40)];
        [self addSubview:self.lblTitle];
        
        self.lblName =[[UILabel alloc]initWithFrame:CGRectMake(68, 43, self.frame.size.width-68-1, 30)];
        [self.lblName setFont:self.gv.fontHintForHebrew];
        [self.lblName setTextColor:[UIColor darkGrayColor]];
        [self addSubview:self.lblName];
        
        //usage time
        double padding=8;
        self.lblUsageTitle=[[UILabel alloc] initWithFrame:CGRectMake(15, 87.5, frame.size.width-15, 30)];
        [self.lblUsageTitle setTextColor:[UIColor whiteColor]];
        [self.lblUsageTitle setFont:self.gv.fontNormalForHebrew];
        [self addSubview:self.lblUsageTitle];
        self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:",[DB getUI:@"usage_time"]];
        CGSize expectedUsageSize=[self.lblUsageTitle sizeThatFits:CGSizeMake(frame.size.width-15, 30)];
        self.loadingForUsage=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake(self.lblUsageTitle.frame.origin.x+expectedUsageSize.width+10, self.lblUsageTitle.frame.origin.y+expectedUsageSize.height/2, expectedUsageSize.height, expectedUsageSize.height)  thick:1];
        [self addSubview:self.loadingForUsage];

        //place count;
        self.lblBuildedPlaceCount=[[UILabel alloc] initWithFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.origin.y+self.lblUsageTitle.frame.size.height+padding,frame.size.width-self.lblUsageTitle.frame.origin.x , self.lblUsageTitle.frame.size.height)];
        [self.lblBuildedPlaceCount setTextColor:[UIColor whiteColor]];
        [self.lblBuildedPlaceCount setFont:self.gv.fontNormalForHebrew];
        [self.lblBuildedPlaceCount setText:[NSString stringWithFormat:@"%@:",[DB getUI:@"builded_place"]]];
        [self addSubview:self.lblBuildedPlaceCount];
        CGSize expectedBuildedPlace=[self.lblBuildedPlaceCount sizeThatFits:CGSizeMake(self.frame.size.width-self.lblBuildedPlaceCount.frame.origin.x, 30)];
        self.loadingForBuildedPlace=[[LoadingCircle alloc]initWithFrameAndThick:CGRectMake(self.lblBuildedPlaceCount.frame.origin.x+expectedBuildedPlace.width+10, self.lblBuildedPlaceCount.frame.origin.y+expectedBuildedPlace.height/2, expectedBuildedPlace.height, expectedBuildedPlace.height) thick:1.0f];
        [self addSubview:self.loadingForBuildedPlace];
        
        //review count;
        self.lblReviewCount=[[UILabel alloc]initWithFrame:CGRectMake(self.lblUsageTitle.frame.origin.x, self.lblBuildedPlaceCount.frame.origin.y+self.lblBuildedPlaceCount.frame.size.height+padding, frame.size.width-self.lblUsageTitle.frame.origin.x, self.lblUsageTitle.frame.size.height)];
        [self.lblReviewCount setText:[NSString stringWithFormat:@"%@",[DB getUI:@"review"]]];
        [self.lblReviewCount setFont:self.gv.fontNormalForHebrew];
        [self.lblReviewCount setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lblReviewCount];
        CGSize expectedSizeOfReviewCount=[self.lblReviewCount sizeThatFits:CGSizeMake(frame.size.width-self.lblUsageTitle.frame.origin.x, 30)];
        self.loadingForReviewCount=[[LoadingCircle alloc]initWithFrameAndThick:CGRectMake(self.lblReviewCount.frame.origin.x+expectedSizeOfReviewCount.width+10, self.lblReviewCount.frame.origin.y+expectedSizeOfReviewCount.height/2, expectedSizeOfReviewCount.height, expectedSizeOfReviewCount.height) thick:1.0f];
        [self addSubview:self.loadingForReviewCount];

    }
    return self;
}
-(void) initProfile{
    [self loadProfile];
    self.lblName.text=self.gv.localUserName;
}
//memory leak risk
-(void) loadProfile{
    [self.timer invalidate];
    self.timer=nil;
    self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:",[DB getUI:@"usage_time"]];

    [self.loadingForUsage start];
    [self.loadingForBuildedPlace start];
    [self.loadingForReviewCount start];
    
    NSString *accessToken=@"";
    if(self.gv.loginType==Facebook){
        accessToken=[FBSession activeSession].accessTokenData.accessToken;
    }else if(self.gv.loginType==Google){
        accessToken=self.gv.googleAccessToken;
    }
    [UserInteractionLog getAsyncProfile:self.gv.localUserId accessToken:accessToken completion:^(NSMutableDictionary *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalSecondsFromRemote=[[[data valueForKey:@"result"] valueForKey:@"usage_time"] intValue];
            //from db send error or save remote not succcess.
            int usageSecondsFromDB=[UserInteractionLog getUsageSecondsFromDB];
            self.totalSecondsFromRemote+=usageSecondsFromDB;
            
            //usage time
            self.lblUsageTitle.text=[NSString stringWithFormat:@"%@:  %@",[DB getUI:@"usage_time" ],[self calculateTimeWithSec:self.totalSecondsFromRemote]];
            
            //builded place count
            int buildedPlaceCount=[[[data valueForKey:@"result"] valueForKey:@"builded_place_count"] intValue];
            self.lblBuildedPlaceCount.text=[NSString stringWithFormat:@"%@:  %d",[DB getUI:@"builded_place"],buildedPlaceCount];
            
            //review count;
            self.lblReviewCount.text=[NSString stringWithFormat:@"%@:  %d",[DB getUI:@"review"],[[[data valueForKey:@"result"] valueForKey:@"review_count"] intValue]];
            
            self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
            

            [self.loadingForUsage stop];
            [self.loadingForBuildedPlace stop];
            [self.loadingForReviewCount stop];
        });
    }];
}

-(void)timerStart{
    self.gv.appExitDate=[NSDate date];
    NSTimeInterval secondsBetween = [self.gv.appExitDate timeIntervalSinceDate:self.gv.appLaunchDate];

    ViewControllerRoot *root=(ViewControllerRoot *)self.gv.viewControllerRoot;
    if(secondsBetween+self.totalSecondsFromRemote>5*60){
        [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"5_minutes_usage"];
    }
    if(secondsBetween+self.totalSecondsFromRemote>5*60*2){
        [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"10_minutes_usage"];
    }
    if(secondsBetween+self.totalSecondsFromRemote>5*60*4){
        [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"20_minutes_usage"];
    }
    if(secondsBetween+self.totalSecondsFromRemote>5*60*8){
        [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"40_minutes_usage"];
    }
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
