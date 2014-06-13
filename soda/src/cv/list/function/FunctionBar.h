//
//  FunctionBar.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonLocation.h"
#import "ButtonFilter.h"
#import "ButtonSort.h"
#import "ViewPanelForLocation.h"
#import "ViewPanelForFilter.h"
#import "ViewPanelForSort.h"

@interface FunctionBar : ViewProtoType
@property ButtonLocation *btnLocation;
@property ButtonFilter *btnFilter;
@property ButtonSort *btnSort;
@property ViewPanelForLocation *viewPanelForLocation;
@property ViewPanelForFilter *viewPanelForFilter;
@property ViewPanelForSort *viewPanelForSort;
@property UIView *currentShowPanel;
@property BOOL isExpanded;
@property NSMutableDictionary *dicViewPanel;
@property NSMutableDictionary *dicButtonFunction;
-(void)switchViewPanelWithTargetButton:(ButtonFunction *) btn;
-(void)contractAllWithoutAnimation;
-(void)rebackAllButtonWithoutAnimation;
@end
