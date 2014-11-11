//
//  ViewControllerTop.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewSearch.h"
#import "ButtonSearch.h"
#import "ButtonAdd.h"
#import "ViewControllerProtoType.h"
#import "BreadCrumbView.h"
#import "ButtonRefresh.h"
#import "LabelForChangeUILang.h"

@interface ViewControllerTop : ViewControllerProtoType
@property  TextViewSearch *txtSearch;
@property  ButtonSearch *btnSearch;
@property  ButtonAdd *btnAdd;
@property ButtonRefresh *btnRefresh;
@property LabelForChangeUILang *lblHint;
@property BreadCrumbView *breadCrumbView;
@property BOOL isSearchList;
-(void)pin;
-(void)search;
-(void)statusCommonToSearch;
-(void)statusSearchToCommon;
-(void)animationShowBreadCrumb:(NSString *)iconName name:(NSString *)name;
-(void)statusListToCommon;
@end
