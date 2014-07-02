//
//  ScrollViewProfile.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ButtonLogout.h"
#import "SwitchProfile.h"
#import "LoadingCircle.h"
@interface ViewProfile : ViewExpandedPanel
@property UILabel *lblName;

@property UILabel *lblUsageTitle;
@property LoadingCircle *loadingForUsage;

@property UILabel *lblBuildedPlaceCount;
@property LoadingCircle *loadingForBuildedPlace;

@property UILabel *lblReviewCount;
@property LoadingCircle *loadingForReviewCount;

@property NSTimer *timer;

@property int totalSecondsFromRemote;
-(void) loadProfile;
-(void)timerStop;
-(void) initProfile;
@end
