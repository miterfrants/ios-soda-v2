//
//  ScrollViewControllerList.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerProtoType.h"
#import "GV.h"
#import "ScrollViewList.h"
#import "FunctionBar.h"
#import "LoadingBar.h"
#import "KeyboardTopInput.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CustomizeMarker.h"
@interface ScrollViewControllerList : ViewControllerProtoType<CLLocationManagerDelegate, GMSMapViewDelegate>
@property ScrollViewList *scrollViewList;

@property NSString *nextPageToken;
@property CLLocationManager *locationManager;
@property NSArray *arrRadarResult;
@property NSMutableArray *arrMarker;
@property int currReulstIndex;
@property BOOL isLoadingList;
@property BOOL isEndedForSearchResult;
@property NSString *keyword;
@property NSString *types;
@property FunctionBar *viewFunBar;
@property GMSMapView *mapview;
@property double distance;
@property int createIndex;
@property int totalIndex;
@property int targetIndex;
@property LoadingBar *loading;
@property BOOL isCancelCurrentLoadItemListMarker;
@property NSMutableArray *arrItemList;
@property UIImageView *noDataCat;
@property BOOL isShowNoDataCate;
@property BOOL isHidingNoDataCat;
@property ButtonProtoType *btnNext;
@property ButtonProtoType *btnPrevious;
-(void)showNoDataCat;
-(void)hideNoDataCat;

-(void)animationShowList;
-(void)animationHideList;
-(void)loadListAndInitWithKeyword:(NSString *)keyword type:(NSString *) type dist:(double) dist center:(CLLocationCoordinate2D) center;
-(void)loadNextPageList;
-(void)refresh;
-(BOOL)isExistfilterCondition;
-(BOOL)isExistSortingKey;
-(void)sortingAndFilterArrItemList;

@end