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
@property UILabel *lblBuildedPlaceCount;
@property UILabel *lblUsageTitle;
@property LoadingCircle *loadingForUsage;
@property NSTimer *timer;
@property LoadingCircle *loadingForCoin;
@property int totalSecondsFromRemote;
@property int totalSecondsFromLocal;
-(void) loadUsageTime;
-(void)timerStop;
-(void) initProfile;
@end
