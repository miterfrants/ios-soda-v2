//
//  ScrollViewControllerList.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewControllerList.h"
#import "ScrollViewControllerCate.h"
#import "Util.h"
#import "DB.h"
#import "ListItem.h"
#import "ButtonCate.h"
#import "ButtonInputForComment.h"
#import "ButtonExpand.h"
#import "CustomizeInfoWindow.h"


@interface ScrollViewControllerList ()

@end

@implementation ScrollViewControllerList
@synthesize scrollViewList,gv,nextPageToken,locationManager,arrRadarResult,currReulstIndex,keyword,types,viewFunBar,arrItemList,isShowNoDataCate,isHidingNoDataCat;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.gv=[GV sharedInstance];
        
        arrItemList=[[NSMutableArray alloc] init];
        
        scrollViewList=[[ScrollViewList alloc] initWithFrame:CGRectMake(0, 0, gv.screenW, gv.screenH-80)];
        [self.view addSubview:scrollViewList];
        scrollViewList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.btnMore= [[ButtonMore alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.btnMore setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];

        [self.btnMore setHidden:YES];
        [self.btnMore addTarget:self action:@selector(loadNextPageList) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewList addSubview:self.btnMore];
        
        
        self.loading=[[LoadingCircle alloc] initWithFrame:CGRectMake((self.gv.screenW-30)/2, (150-30)/2+40,30, 30)];
        [self.view addSubview:self.loading];
        [self.loading setHidden:YES];
        
        isShowNoDataCate=NO;
        isHidingNoDataCat=NO;
        
        self.noDataCat=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lazy_cat.png"]];
        [self.noDataCat setFrame:CGRectMake((self.gv.screenW-self.noDataCat.frame.size.width/2)/2-40, 70, self.noDataCat.frame.size.width/2, self.noDataCat.frame.size.height/2)];
        [self.view addSubview:self.noDataCat];
        UILabel *lblNoData=[[UILabel alloc]initWithFrame:CGRectMake(self.noDataCat.frame.size.width, self.noDataCat.frame.size.height-40, 70, 28)];
        [lblNoData setLineBreakMode:NSLineBreakByCharWrapping];
        [lblNoData setFont:self.gv.fontListFunctionTitle];
        [lblNoData setTextColor:[UIColor whiteColor]];
        [lblNoData setText:@"No Data."];
        [self.noDataCat addSubview:lblNoData];
        [self.noDataCat setAlpha:0.0];
        [self.noDataCat setHidden:YES];

        
        viewFunBar=[[FunctionBar alloc] initWithFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
        [viewFunBar setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];
        viewFunBar.clipsToBounds=YES;
        [self.view addSubview:viewFunBar];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0
                                                                longitude:0
                                                                     zoom:15];
        self.mapview = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.gv.screenW, self.gv.screenH-80-150) camera:camera];
        self.mapview.myLocationEnabled = YES;
        self.mapview.accessibilityElementsHidden=NO;
        self.mapview.delegate=self;
        
        self.btnNext=[[ButtonProtoType alloc] initWithFrame:CGRectMake(self.gv.screenW-10-44, self.mapview.frame.size.height-10-44, 44, 44)    ];
        self.btnNext.viewBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next.png"]];
        self.btnNext.iconOverNameForProtoType=@"next_over.png";
        self.btnNext.iconNameForProtoType=@"next.png";
        [self.btnNext.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self.btnNext addSubview:self.btnNext.viewBg];
        [self.btnNext addTarget:self action:@selector(nextMarker) forControlEvents:UIControlEventTouchUpInside];
        [self.mapview addSubview:self.btnNext];

        
        self.btnPrevious=[[ButtonProtoType alloc] initWithFrame:CGRectMake(10,self.mapview.frame.size.height-10-44, 44, 44)    ];
        self.btnPrevious.viewBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"previous.png"]];
        self.btnPrevious.iconOverNameForProtoType=@"previous_over.png";
        self.btnPrevious.iconNameForProtoType=@"previous.png";
        [self.btnPrevious.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self.btnPrevious addSubview:self.btnPrevious.viewBg];
        [self.btnPrevious addTarget:self action:@selector(previousMarker) forControlEvents:UIControlEventTouchUpInside];
        [self.mapview addSubview:self.btnPrevious];

        self.btnPrevious.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.btnPrevious.layer.shadowRadius = 5.0f;
        self.btnPrevious.layer.shadowOpacity = .5f;
        self.btnPrevious.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor
        ;
        
        self.btnNext.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.btnNext.layer.shadowRadius = 5.0f;
        self.btnNext.layer.shadowOpacity = .5f;
        self.btnNext.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor
        ;
        arrRadarResult=[[NSArray alloc] init];
    }
    return self;
}

//peter modify memory leak risk
-(void)nextMarker{
    CustomizeMarker *marker=(CustomizeMarker *)self.mapview.selectedMarker;
    CustomizeMarker *nextMarker=nil;
    scrollViewList.isAutoAnimation=YES;
    if(marker.markerSeq+1>self.arrMarker.count-1){
        nextMarker=(CustomizeMarker *)[self.arrMarker objectAtIndex:0];
    }else{
        nextMarker=(CustomizeMarker *)[self.arrMarker objectAtIndex:marker.markerSeq+1];
    }
    if(scrollViewList.contentSize.height<nextMarker.markerSeq*150+self.gv.screenH-80){
        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, nextMarker.markerSeq*150+self.gv.screenH-80)];
    }
    [scrollViewList setContentOffset:CGPointMake(0,nextMarker.markerSeq*150+40) animated:NO];

    ListItem *oriItem=(ListItem *)marker.userData;
    ListItem *nextItem=(ListItem *)nextMarker.userData;
    [self.mapview removeFromSuperview];
    [nextItem.scrollViewDetailMap addSubview:self.mapview];
    oriItem.isExpanded=NO;
    [oriItem.blurBg setAlpha:1.0];
    [oriItem.maskBg setAlpha:1.0];
    [oriItem.blurBg setHidden:NO];
    [oriItem.maskBg setHidden:NO];
    [oriItem.viewMiddleLigthBorder setAlpha:0.0f];
    [oriItem.viewMiddleDarkBorder setAlpha:0.0f];
    [oriItem.viewGradientBgForName setFrame:CGRectMake(0, -45, self.gv.screenW, 45)];
    [oriItem.viewBottomBorder setFrame:CGRectMake(0, 0, self.gv.screenW, 1)];
    [oriItem setFrame:CGRectMake(0, oriItem.frame.origin.y, self.gv.screenW, 150)];
    [[oriItem.dicDetailPanel objectForKey:@"map"] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
    for(int i =0;i<[arrItemList count];i++){
        ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
        if([item isEqual:self]){
            continue;
        }
        if(item.seq==-1){
            continue;
        }
        if(!item.isShow){
            continue;
        }
        if(item.seq>oriItem.seq){
            [item setFrame:CGRectMake(0, item.seq*150, self.gv.screenW, 150)];
        }
    }

    nextItem.expandName=@"map";
    nextItem.poseOfCurrentReview=0;
    [nextItem generateReview];
    [nextItem.scrollViewDetailReview setContentOffset:CGPointMake(0, 0)];
    nextItem.isExpanded=YES;
    [scrollViewList bringSubviewToFront:nextItem];
    [nextItem.btnComment setFrame:CGRectMake(28-self.gv.screenW, nextItem.btnComment.frame.origin.y, nextItem.btnComment.frame.size.width, nextItem.btnComment.frame.size.height)];
    [nextItem.lblIForComment setFrame:CGRectMake(20-self.gv.screenW, nextItem.lblIForComment.frame.origin.y, nextItem.lblIForComment.frame.size.width, nextItem.lblIForComment.frame.size.height)];

    for(NSString *key in nextItem.dicDetailPanel){
        if(![key isEqualToString:@"map"]){
            [[nextItem.dicDetailPanel objectForKey:key] setFrame:CGRectMake(-self.gv.screenW, 150, self.gv.screenW, self.gv.screenH-40-150)];
        }else{
            [[nextItem.dicDetailPanel objectForKey:key] setFrame:CGRectMake(0, 150, self.gv.screenW, 0)];
        }
    }
    [nextItem setFrame:CGRectMake(0, nextItem.seq*150+40, self.gv.screenW, self.gv.screenH-80)];
    for(int i =0;i<[arrItemList count];i++){
        ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
        if(item.seq==-1){
            continue;
        }
        if(!item.isShow){
            continue;
        }
        if(item.seq>nextItem.seq){
            [item setFrame:CGRectMake(0, item.seq*150+self.gv.screenH-80-150+40, self.gv.screenW, 150)];
        }
    }

    [[nextItem.dicDetailPanel objectForKey:@"map"] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
     [nextItem.viewMiddleLigthBorder setAlpha:1.0f];
     [nextItem.viewMiddleDarkBorder setAlpha:1.0f];
     [nextItem.viewBottomBorder setFrame:CGRectMake(0, self.gv.screenH-80-150, self.gv.screenW, 1)];
     [nextItem.blurBg setAlpha:0.0f];
     [nextItem.maskBg setAlpha:0.0f];
     if(nextItem.imgViewBg.image!=nil){
         [nextItem.viewGradientBgForName setFrame:CGRectMake(0, 0, self.gv.screenW, 45)];
     }
    [self.mapview setSelectedMarker:nextMarker];
    scrollViewList.isAutoAnimation=NO;
}
-(void)previousMarker{
    CustomizeMarker *marker=(CustomizeMarker *)self.mapview.selectedMarker;
    CustomizeMarker *prevMarker=nil;
    scrollViewList.isAutoAnimation=YES;
    if(marker.markerSeq-1<0){
        prevMarker=(CustomizeMarker *)[self.arrMarker objectAtIndex:self.arrMarker.count-1];
    }else{
        prevMarker=(CustomizeMarker *)[self.arrMarker objectAtIndex:marker.markerSeq-1];
    }
    [scrollViewList setContentOffset:CGPointMake(0,(marker.markerSeq+1)*150) animated:NO];
    [self.mapview removeFromSuperview];
    ListItem *oriItem=(ListItem *)marker.userData;
    ListItem *prevItem=(ListItem *)prevMarker.userData;
    [prevItem.scrollViewDetailMap addSubview:self.mapview];
    
    [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (scrollViewList.subviews.count-3)*150+40+40)];
    [scrollViewList setContentOffset:CGPointMake(0,prevMarker.markerSeq*150+40) animated:NO];
    
    [self.mapview removeFromSuperview];
    [prevItem.scrollViewDetailMap addSubview:self.mapview];
    oriItem.isExpanded=NO;
    [oriItem.blurBg setAlpha:1.0];
    [oriItem.maskBg setAlpha:1.0];
    [oriItem.blurBg setHidden:NO];
    [oriItem.maskBg setHidden:NO];
    [oriItem.viewMiddleLigthBorder setAlpha:0.0f];
    [oriItem.viewMiddleDarkBorder setAlpha:0.0f];
    [oriItem.viewGradientBgForName setFrame:CGRectMake(0, -45, self.gv.screenW, 45)];
    [oriItem.viewBottomBorder setFrame:CGRectMake(0, 0, self.gv.screenW, 1)];
    [oriItem setFrame:CGRectMake(0, oriItem.frame.origin.y, self.gv.screenW, 150)];
    [[oriItem.dicDetailPanel objectForKey:@"map"] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
    for(int i =0;i<[arrItemList count];i++){
        ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
        if([item isEqual:self]){
            continue;
        }
        if(item.seq==-1){
            continue;
        }
        if(!item.isShow){
            continue;
        }
        if(item.seq>oriItem.seq){
            [item setFrame:CGRectMake(0, item.seq*150, self.gv.screenW, 150)];
        }
    }
    
    prevItem.expandName=@"map";
    prevItem.poseOfCurrentReview=0;
    [prevItem generateReview];
    [prevItem.scrollViewDetailReview setContentOffset:CGPointMake(0, 0)];
    prevItem.isExpanded=YES;
    [scrollViewList bringSubviewToFront:prevItem];
    [prevItem.btnComment setFrame:CGRectMake(28-self.gv.screenW, prevItem.btnComment.frame.origin.y, prevItem.btnComment.frame.size.width, prevItem.btnComment.frame.size.height)];
    [prevItem.lblIForComment setFrame:CGRectMake(20-self.gv.screenW, prevItem.lblIForComment.frame.origin.y, prevItem.lblIForComment.frame.size.width, prevItem.lblIForComment.frame.size.height)];
    
    for(NSString *key in prevItem.dicDetailPanel){
        if(![key isEqualToString:@"map"]){
            [[prevItem.dicDetailPanel objectForKey:key] setFrame:CGRectMake(-self.gv.screenW, 150, self.gv.screenW, self.gv.screenH-40-150)];
        }else{
            [[prevItem.dicDetailPanel objectForKey:key] setFrame:CGRectMake(0, 150, self.gv.screenW, 0)];
        }
    }
    [prevItem setFrame:CGRectMake(0, prevItem.frame.origin.y, self.gv.screenW, self.gv.screenH-80)];
    
    for(int i =0;i<[arrItemList count];i++){
        ListItem* item=(ListItem*) [arrItemList objectAtIndex:i];
        if(item.seq==-1){
            continue;
        }
        if(!item.isShow){
            continue;
        }
        if(item.seq>prevItem.seq){
            [item setFrame:CGRectMake(0, item.seq*150+self.gv.screenH-80-150, self.gv.screenW, 150)];
        }
    }
    
    [[prevItem.dicDetailPanel objectForKey:@"map"] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
    [prevItem.viewMiddleLigthBorder setAlpha:1.0f];
    [prevItem.viewMiddleDarkBorder setAlpha:1.0f];
    [prevItem.viewBottomBorder setFrame:CGRectMake(0, self.gv.screenH-80-150, self.gv.screenW, 1)];
    [prevItem.blurBg setAlpha:0.0f];
    [prevItem.maskBg setAlpha:0.0f];
    if(prevItem.imgViewBg.image!=nil){
        [prevItem.viewGradientBgForName setFrame:CGRectMake(0, 0, self.gv.screenW, 45)];
    }
    [self.mapview setSelectedMarker:prevMarker];
    scrollViewList.isAutoAnimation=NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) animationShowList{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self.view setFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}

-(void) animationHideList{
    [viewFunBar.viewPanelForLocation.txtCenterAdderss stopObserver];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self.view setFrame:CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished){
             //remove
             NSLog(@"clear and stop loading");
             [self clearList];
             //[self.loading stop];
             arrItemList=[[NSMutableArray alloc] init];
             [viewFunBar contractAllWithoutAnimation];
             [viewFunBar rebackAllButtonWithoutAnimation];
             [self.noDataCat setAlpha:0.0];
             [self.noDataCat setHidden:YES];
             ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
             scrollViewControllerCate.selectedButtonCate=nil;
         }
     }];
}
-(void) refresh{
    [self statusToList];
    self.isCancelCurrentLoadItemListMarker=YES;
    [self.gv.GooglePlaceDetailQueue cancelAllOperations];
    ButtonFunction *selectedButtonForFunctionBar=nil;
    for(NSString *key in self.viewFunBar.dicButtonFunction){
        ButtonFunction *tempButton=(ButtonFunction *)[self.viewFunBar.dicButtonFunction objectForKey:key];
        if(tempButton.isSelected){
            selectedButtonForFunctionBar=tempButton;
        }
    }
    UIView *selectedPanel=nil;
    if(selectedButtonForFunctionBar!=nil){
        selectedPanel=(UIView *)[self.viewFunBar.dicViewPanel objectForKey:selectedButtonForFunctionBar.name];
    }

    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self.scrollViewList setAlpha:0.0f];
         [self.scrollViewList setFrame:CGRectMake(0, 0, self.gv.screenW, self.gv.screenH-80)];
         [self.viewFunBar setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
         self.viewFunBar.isExpanded=NO;
     } completion:^(BOOL finished){
         if (finished){
             [scrollViewList iniMarker];
             [viewFunBar rebackAllButtonWithoutAnimation];
             [viewFunBar contractAllWithoutAnimation];
             ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
             ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
             [self loadListAndInitWithKeyword:selected.keyword type:@"" dist:selected.distance center:selected.centerLocation];
             [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
              {
                  [self.scrollViewList setAlpha:1.0f];
              } completion:^(BOOL finished){
                  if (finished){

                  }
              }];
         }
     }];
}

-(void) loadListAndInitWithKeyword:(NSString *)pKeyword type:(NSString *) pType dist:(double)dist center:(CLLocationCoordinate2D) center{
    NSLog(@"%@",@"loadListWithKeyword");
    NSLog(@"distance:%f",dist);
    [self.scrollViewList setContentOffset:CGPointMake(0, 0)];
    self.isLoadingList=YES;
    self.keyword=pKeyword;
    self.distance=dist;
    self.types=pType;
    self.isEndedForSearchResult=NO;
    self.createIndex=0;
    self.totalIndex=0;
    self.targetIndex=0;
    self.isCancelCurrentLoadItemListMarker=NO;
    [self.scrollViewList setScrollEnabled:YES];
    self.arrItemList=[[NSMutableArray alloc] init];
    [self.scrollViewList setContentSize:CGSizeMake(self.gv.screenW, 0)];
    [self clearList];
    [self initialFunctionBarProperty];
    [self hideNoDataCat];
    [self.viewFunBar setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
//    [self.loading process:0 completion:nil];

    CLLocationCoordinate2D searchCenter;
    if(center.latitude>0 && center.longitude>0){
        searchCenter=CLLocationCoordinate2DMake(center.latitude, center.longitude);
    }else{
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        searchCenter=CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
    }

    if([self isExistSortingKey]){
        //[self.loading start];
        [self.loading setAlpha:0.0f];
        [self.loading setHidden:NO];
        [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [self.loading setAlpha:1.0f];
         } completion:^(BOOL finished) {
             if (finished){
                 [self.loading start];
                 [self sendRequest:searchCenter dist:dist pKeyword:pKeyword pType:pType];
             }
         }];
    }else{
        [self.loading stop];
        [self sendRequest:searchCenter dist:dist pKeyword:pKeyword pType:pType];
    }

}
-(void) sendRequest:(CLLocationCoordinate2D) searchCenter dist:(double) dist pKeyword:(NSString*) pKeyword pType:(NSString *) pType {
    //check local server
    NSString *strUrlFromLocalServer=[NSString stringWithFormat:@"%@://%@/%@?action=%@&lat=%f&lng=%f&dist=%f&tag=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerPlace,self.gv.actionSearchPlace,searchCenter.latitude,searchCenter.longitude,dist,pKeyword];
    NSLog(@"%@",strUrlFromLocalServer);
    [Util jsonAsyncWithUrl:strUrlFromLocalServer target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:3 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        NSLog(@"local data finish");
        NSMutableArray *arrFromLocal=[data objectForKey:@"results"];
        NSMutableArray *arrFromGoogle=[[self getRadarPlaceFromGoogle:searchCenter dist:dist pKeyword:pKeyword pType:pType] objectForKey:@"results"];
        NSLog(@"google result:%d",(int)arrFromGoogle.count);
        NSLog(@"local result:%d",(int)arrFromLocal.count);
        BOOL isFromLocal =NO;
        if(arrFromLocal.count==0 && arrFromGoogle.count==0){
            NSLog(@"NO DATA");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNoDataCat];
                [self.loading hide];
            });
            return;
        }else if(arrFromLocal.count<arrFromGoogle.count){
            self.arrRadarResult=arrFromGoogle;
        }else if(arrFromLocal.count>=arrFromGoogle.count){
            isFromLocal =YES;
            NSLog(@"local result");
            self.arrRadarResult=arrFromLocal;
            //local 端資料比較多用local 端的
            //update empty data and expired data   
        }
        NSLog(@"radar result:%d",(int) [arrRadarResult count]);
        self.totalIndex=(int) [arrRadarResult count]-1;
        int maxLen=(int) [arrRadarResult count];
        //no sorting key load by onece
        if(![self isExistSortingKey]){
            if(maxLen>self.gv.listBufferCount){
                maxLen=self.gv.listBufferCount;
            }else{
                //ScrollView Load NextPage marker;
                self.isEndedForSearchResult=YES;
            }
        }else{
            [scrollViewList setAlpha:0.0f];
            self.isEndedForSearchResult=YES;
        }
        if(maxLen>0){
            self.targetIndex=maxLen-1;
        }else{
            self.targetIndex=0;
        }
        NSLog(@"targetIndex:%d",self.targetIndex);
        NSLog(@"loading detail count:%d",maxLen);
        
        BOOL isExistFilterCondition=[self isExistfilterCondition];
        BOOL isExistSortingKey=[self isExistSortingKey];
        NSLog(@"creat item instance");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createItemFromRadarResultWithIndex:0 isExistFilterCondition:isExistFilterCondition isExistSortingKey:isExistSortingKey isFromLocal:isFromLocal];
        });

        if(!isExistFilterCondition){
            if(isExistSortingKey){
                [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, [arrRadarResult count]*150)];
            }else{
                if(self.targetIndex<self.totalIndex){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40+40)];
                        [self.btnMore setFrame:CGRectMake(0, (self.targetIndex+1)*150+40, 320, 40)];
                        [self.btnMore setHidden:NO];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40)];
                        [self.btnMore setHidden:YES];
                    });
                }
            }
        }
    } queue:self.gv.backgroundThreadManagement];
}

-(NSDictionary *)getRadarPlaceFromGoogle:(CLLocationCoordinate2D) searchCenter dist:(double) dist pKeyword:(NSString*) pKeyword pType:(NSString *) pType {
    NSMutableString *nearbySearchURL=[[NSMutableString alloc] init];
    [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%f,%f&radius=%f&keyword=%@&sensor=false&key=%@&rankBy=prominence&types=%@&language=%@",searchCenter.latitude,searchCenter.longitude,dist,pKeyword,[GV sharedInstance].googleWebKey,pType, [Util langIOSCode:[DB getSysConfig:@"lang"]]];
    
    NSMutableDictionary *dicHeaders=[[NSMutableDictionary alloc]init];
    [dicHeaders setValue:@"" forKey:@"user-agent"];
    NSLog(@"search url:%@",nearbySearchURL);
    //這邊要確定只有 sendRequest 這邊過來要不然會卡住main thread
    if([NSThread isMainThread]){
        NSException *e = [NSException
                          exceptionWithName:@"main thread exception"
                          reason:@"ScrollViewControllerList -getRadarPlaceFromGoogle is needed background thread"
                          userInfo:nil];
        @throw e;
    }
    NSDictionary *jsonResult=[Util jsonWithUrl:nearbySearchURL];
    return jsonResult;
}

-(BOOL)isExistfilterCondition{
    ButtonCate *selected=[self getSelectedButtonCate];
    if(selected.isOnlyShowFavorite){
        return YES;
    }
    if(selected.isOnlyShowPhone){
        return YES;
    }
    if(selected.isOnlyShowOpening){
        return YES;
    }
    if(selected.isOnlyShowOfficialSuggest){
        return YES;
    }
    if(selected.rating>0){
        return YES;
    }
    return NO;
}

-(BOOL)isExistSortingKey{
    ButtonCate *selected=[self getSelectedButtonCate];
    if(selected.sortingKey.length>0){
        return YES;
    }
    return NO;
}
-(void) createItemFromRadarResultWithIndex:(int) i isExistFilterCondition:(BOOL) isExistFilterCondition isExistSortingKey:(BOOL) isExistSortingKey isFromLocal:(BOOL) isFromLocal{
    //如果有過濾條件不要設定寬高由 ListItem addLoadGooglePlaceDetailToQueue 載完資料後設定 但要檢查一下y有沒有重複
    //這邊initail 50%; loading 50%;
    //如果我alloc 和process bar 一起跑的話 process bar會被卡住 所以做完一次讓process bar動畫跑完再initial
    ListItem *item=[[ListItem alloc]init];
//loading progress bar
//    [self.loading process:(double)((i*0.5)/self.totalIndex) completion:^{
        //initial
        [item setFrame:CGRectMake(0, i*150+40, gv.screenW, 150)];
        if(!isExistSortingKey){
            item.isShow=YES;
            item.seq=i;
            [item.loadingCircle start];
            [scrollViewList addSubview:item];
            [item.contentCon setAlpha:0.0];
        }else{
            item.isShow=NO;
            [item.contentCon setAlpha:1.0];
        }

        NSMutableDictionary *dicDataItem= [arrRadarResult objectAtIndex:i];
        //要不要 distance
        if(isFromLocal){
            item.googleId=[[dicDataItem objectForKey:@"result"] valueForKey:@"id"];
            item.lat=[[[[[dicDataItem objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
            item.lng=[[[[[dicDataItem objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
            item.googleRef=[[dicDataItem objectForKey:@"result"] valueForKey:@"reference"];
            item.jsonBaseData=[dicDataItem objectForKey:@"result"];
        }else{
            item.googleId=[dicDataItem valueForKey:@"id"];
            item.lat=[[[[dicDataItem objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lat"] doubleValue];
            item.lng=[[[[dicDataItem objectForKey:@"geometry"] objectForKey:@"location"] valueForKey:@"lng"] doubleValue];
            item.googleRef=[dicDataItem valueForKey:@"reference"];
        }
        [arrItemList addObject:item];
        currReulstIndex=i;
        NSLog(@"create:%@",[NSString stringWithFormat:@"%d/%d",currReulstIndex,self.totalIndex]);
        //next one
        if(currReulstIndex<self.targetIndex){
            [self createItemFromRadarResultWithIndex:currReulstIndex+1 isExistFilterCondition:isExistFilterCondition isExistSortingKey:isExistSortingKey isFromLocal:isFromLocal];
        }else{
            NSLog(@"create item instance finish;");
            NSLog(@"finish and target index:%d",self.targetIndex);
            if(isExistSortingKey){
                currReulstIndex=self.gv.listBufferCount-1;
            }
            if(isFromLocal){
                for(int i=currReulstIndex-self.gv.listBufferCount+1;i<=self.targetIndex;i++){
                    ListItem *currItem=(ListItem *)[arrItemList objectAtIndex:i];
                    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(initialItem:) object:currItem];
                    [self.gv.backgroundThreadManagement addOperation:operation];
                }
            }else{
                for(int i=currReulstIndex-self.gv.listBufferCount+1;i<=self.targetIndex;i++){
                    ListItem *currItem=(ListItem *)[arrItemList objectAtIndex:i];
                    [currItem addLoadGooglePlaceDetailToQueue:currItem.googleRef];
                }
            }
            //ScrollView Load NextPage marker;
            self.isLoadingList=NO;
        }
//    }];
    
}
-(void)initialItem:(ListItem*) item{
    [item initialItem:item.jsonBaseData isFromLocal:YES];
}
//add subview all
-(void)sortingAndFilterArrItemList{
    ButtonCate *selected=[self getSelectedButtonCate];
    NSSortDescriptor *sort=nil;
    if([selected.sortingKey isEqual:@"rating"]){
        sort=[NSSortDescriptor sortDescriptorWithKey:@"rate" ascending:NO];
    }else if([selected.sortingKey isEqual:@"distance"]){
        sort=[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    }
    [arrItemList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    int sortingCreateIndex=0;
    for(int i=0;i<arrItemList.count;i++){
        ListItem *item=(ListItem *)[arrItemList objectAtIndex:i];
        //把之前的序號和顯示狀態都清掉
        item.seq=-1;
        item.isShow=NO;
        if(selected.isOnlyShowFavorite && !item.isFavorite){
            continue;
        }
        if(selected.isOnlyShowOpening && !item.isOpening){
            continue;
        }
        if(selected.isOnlyShowOfficialSuggest && !item.isOfficialSuggest){
            continue;
        }
        if(selected.rating>0 && item.rate<selected.rating){
            continue;
        }
        if(selected.isOnlyShowPhone && item.strPhone.length==0){
            continue;
        }
        [scrollViewList addSubview:item];
        [item setFrame:CGRectMake(0, sortingCreateIndex*150+40, self.gv.screenW, 150)];
        [item placeElement];
        //只會進到 setAlpha:1.0f;
        [item displaySelf];
        item.seq=sortingCreateIndex;
        item.isShow=YES;
        sortingCreateIndex+=1;
    }
    [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, 150*(sortingCreateIndex)+40)];
    NSLog(@"sorting finish");
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [scrollViewList setAlpha:1.0f];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}



-(ButtonCate *) getSelectedButtonCate{
    ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
    return selected;
}

-(void)loadNextPageList{
    
    if(self.isEndedForSearchResult){
        return;
    }
    if(self.isLoadingList){
        return;
    }
    int maxLen=(int)self.arrRadarResult.count;
    if(maxLen>currReulstIndex+self.gv.listBufferCount+1){
        maxLen=currReulstIndex+self.gv.listBufferCount+1;
    }else{
        self.isEndedForSearchResult=YES;
    }
    NSLog(@"page:%d",currReulstIndex+self.gv.listBufferCount);
    if(maxLen>0){
        self.targetIndex=maxLen-1;
    }else{
        self.targetIndex=0;
    }
    NSLog(@"targetIndex:%d",self.targetIndex);
    self.isLoadingList=YES;
    if(self.targetIndex<self.totalIndex){
        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40+40   )];
        [self.btnMore setFrame:CGRectMake(0, (self.targetIndex+1)*150+40, 320, 40)];
        [self.btnMore setHidden:NO];
    }else{
        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40)];
        [self.btnMore setHidden:YES];
    }
    [self createItemFromRadarResultWithIndex:self.currReulstIndex+1 isExistFilterCondition:[self isExistfilterCondition] isExistSortingKey:[self isExistSortingKey] isFromLocal:NO];
}

-(void) initialFunctionBarProperty{
    ButtonCate *selected=[self getSelectedButtonCate];
    [viewFunBar.viewPanelForLocation initialDistanceAndCenter:selected];
    [viewFunBar.viewPanelForFilter initialFilterSetting:selected];
    [viewFunBar.viewPanelForSort initialSortinKey:selected];
}

-(void) clearList{
    NSArray *subviews=scrollViewList.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i ] isKindOfClass:[ListItem class]]){
            [[subviews objectAtIndex:i] removeFromSuperview];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //if status is edit selected button
    UITouch* touch=[[event allTouches]anyObject];
    NSLog(@"list:%@",NSStringFromClass(touch.view.class));
    if([touch.view isKindOfClass:[ListItem class]]){
        ListItem *item=(ListItem *)touch.view;
        NSLog(@"%d",item.seq);
    }
    if([GV getGlobalStatus] == LIST_EXPAND &&
        [touch.view isKindOfClass:[LabelForComment class]]
       ){
        NSLog(@"list condition 1: show top keyboard and type comment");
        LabelForComment *lblForComment=(LabelForComment *) touch.view;
        [GV setGlobalStatus:lblForComment.clickToStatus];
    }else if(
         [GV getGlobalStatus]==LIST
        &&
        [touch.view isKindOfClass:[ButtonExpand class]]
        ){
        if([touch.view isKindOfClass:[ButtonLight class]]){
            //Button Light 暫時不實作
            return;
        }
        NSLog(@"list condition 2: 展開detail");
        ListItem* item=(ListItem*)touch.view.superview.superview;
        [item bringSubviewToFront:scrollViewList];
        ButtonExpand *btnExpand=(ButtonExpand *)touch.view;
        [self statusListToExpand:item expandName:btnExpand.name];
    }else if ([GV getGlobalStatus]==LIST_EXPAND &&
              [touch.view isKindOfClass:[ButtonExpand class]]
              ){
        if([touch.view isKindOfClass:[ButtonLight class]]){
            //Button Light 暫時不實作
            return;
        }
        NSLog(@"list condition 3: 縮小 detail 或是 slid 到其他的detail info");
        ListItem* item=(ListItem*)touch.view.superview.superview;
        ButtonExpand *btnExpand=(ButtonExpand *)touch.view;
        if(item.expandName==btnExpand.name){
            [self statusExpandToList:item];
        }else{
            [self slideToOtherExpandWitItem:item willExpandDetailName:btnExpand.name];
        }
    }else if([GV getGlobalStatus] == LIST_EXPAND_WITHKEYBOARD &&
       (
        ![touch.view isKindOfClass:[ButtonComment class]]
        ||
        ![touch.view isKindOfClass:[LabelCheckCoverOver class]]
        )
       ){
        NSLog(@"list condition 4: 點選scrollviewlist 隱藏鍵盤");
        KeyboardTopInput *keyboardTopInput =(KeyboardTopInput *)self.gv.keyboardTopInput;
        [keyboardTopInput hideKeyboard:nil];
        [GV setGlobalStatus:LIST_EXPAND];
    }else if(
             (
              [GV getGlobalStatus]==LIST ||
              [GV getGlobalStatus]==LIST_EXPAND ||
              [GV getGlobalStatus]==LIST_EXPAND_WITHKEYBOARD
              )
             &&
             [touch.view isKindOfClass:[ButtonPhone class]]){
        NSLog(@"list condition 5: 打電話");
        ListItem *item=(ListItem *) touch.view.superview;
        [item call];
    }else if([GV getGlobalStatus]==LIST && [touch.view isKindOfClass:[ButtonFunction class]]){
        NSLog(@"list condition 6: 切換搜尋設定");
        [viewFunBar switchViewPanelWithTargetButton:(ButtonFunction *)touch.view];
    }else if([touch.view isKindOfClass:[ButtonSaveReview class]] && [GV getGlobalStatus]== LIST_EXPAND){
        NSLog(@"list condition 7: 存review");
        ListItem *item=(ListItem *) touch.view.superview.superview;
        [item saveReview];
    }
    else if([touch.view isKindOfClass:[ButtonInputForComment class]]){
        NSLog(@"list condition 8: 展開 keyboard");
        ButtonComment *btnComment=(ButtonComment *)touch.view.superview;
        [self statusExpandToWithKeyboard:btnComment];
    }else if([touch.view isKindOfClass:[ListItem class]]){
        ListItem *item=(ListItem *) touch.view;
        NSLog(@"%@",item.name);
    }
    
    
    
    NSLog(@"%@",@"bubble event:");
    [super touchesEnded:touches withEvent:event];
}

-(void) showNoDataCat{
    isShowNoDataCate=YES;
    if(isHidingNoDataCat){
        return;
    }
    [self.noDataCat setHidden:NO];
    [UIView animateWithDuration:0.34 delay:0.6 options:UIViewAnimationOptionCurveLinear animations:^
     {
         [self.noDataCat setAlpha:1.0f];
     } completion:^(BOOL finished) {
         if (finished){
             isShowNoDataCate=NO;
             if(isHidingNoDataCat){
                 [self hideNoDataCat];
             }
         }
     }];
}

-(void)slideToOtherExpandWitItem:(ListItem *) item willExpandDetailName:(NSString *)willExpandDetailName{
    NSString *originalExpandedName=item.expandName;
    [[item.dicDetailPanel objectForKey:willExpandDetailName] setHidden:NO];
    item.expandName=willExpandDetailName;
    if(self.gv.localUserId ==nil){
        [item.lblIForComment setHidden:YES];
        [item.btnComment setHidden:YES];
    }
    if([willExpandDetailName isEqual:@"review"]){
        [((ScrollViewDetailReview *)[item.dicDetailPanel objectForKey:willExpandDetailName]) setContentOffset:CGPointMake(0, 0)];
        [item.lblIForComment setFrame:CGRectMake(20-self.gv.screenW, item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
        [item.btnComment setFrame:CGRectMake(28-self.gv.screenW, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
    }else if([originalExpandedName isEqual:@"review"]){
        if(item.lblIForComment.frame.origin.x<0){
            [item.lblIForComment setHidden:YES];
        }
        if(item.btnComment.frame.origin.x<0){
            [item.btnComment setHidden:YES];
        }
    }
    [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if([originalExpandedName isEqual:@"review"] && ![willExpandDetailName isEqual:@"review"]){
            [item.lblIForComment setFrame:CGRectMake(self.gv.screenW+item.lblIForComment.frame.origin.x, item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
            [item.btnComment setFrame:CGRectMake(self.gv.screenW+item.btnComment.frame.origin.x, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
        }else if([willExpandDetailName isEqual:@"review"]){
            [item.lblIForComment setFrame:CGRectMake(20, item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
            [item.btnComment setFrame:CGRectMake(28, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
        }
        [[item.dicDetailPanel objectForKey:originalExpandedName] setFrame:CGRectMake(self.gv.screenW, 150, self.gv.screenW, self.gv.screenH-80-150)];
        [[item.dicDetailPanel objectForKey:willExpandDetailName] setFrame:CGRectMake(0, 150, self.gv.screenW, self.gv.screenH-80-150)];
    } completion:^(BOOL finished) {
        if(finished){
            [[item.dicDetailPanel objectForKey:originalExpandedName] setFrame:CGRectMake(-self.gv.screenW, 150, self.gv.screenW, self.gv.screenH-80-150)];
            if([originalExpandedName isEqual:@"review"] && ![willExpandDetailName isEqual:@"review"]){
                [item.lblIForComment setFrame:CGRectMake(20-self.gv.screenW, item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
                [item.btnComment setFrame:CGRectMake(28-self.gv.screenW, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
                [item.lblIForComment setHidden:NO];
                [item.btnComment setHidden:NO];
            }
        }
    }];
}

-(void) hideNoDataCat{
    isHidingNoDataCat=YES;
    if(isShowNoDataCate){
        return;
    }
    [self.noDataCat setHidden:NO];
    [UIView animateWithDuration:0.34 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
     {
         [self.noDataCat setAlpha:0.0f];
     } completion:^(BOOL finished) {
         if (finished){
             [self.noDataCat setHidden:YES];
             isHidingNoDataCat=NO;
             if(isShowNoDataCate){
                 [self showNoDataCat];
             }
         }
     }];
}

-(void)statusExpandToList:(ListItem *)item{
    if([GV getGlobalStatus]!=LIST_EXPAND){
        return;
    }
    [GV setGlobalStatus:LIST];
    [item contractDetailWithAll:YES];
    scrollViewList.scrollEnabled=YES;
}
-(void)statusListToExpand:(ListItem *)item expandName:(NSString *) pExpandName{
    if([GV getGlobalStatus]!=LIST){
        return;
    }
    [GV setGlobalStatus:LIST_EXPAND];
    [item expandDetail:pExpandName animate:YES];

    if(self.mapview.superview!=nil){
        [self.mapview removeFromSuperview];
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:item.lat
                                                            longitude:item.lng
                                                                 zoom:15];
    [self.mapview clear];
    self.arrMarker =[[NSMutableArray alloc]init];
    for(int i=0;i<self.arrItemList.count;i++){
        ListItem *tempItem=[self.arrItemList objectAtIndex:i];
        if(tempItem.isShow){
            CustomizeMarker *marker = [[CustomizeMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(tempItem.lat, tempItem.lng);
            marker.title = tempItem.name;
            marker.snippet=tempItem.address;
            marker.map=self.mapview;
            marker.address=tempItem.address;
            marker.distance=tempItem.distance;
            marker.name=tempItem.name;
            marker.markerSeq=tempItem.seq;
            marker.infoWindowAnchor =CGPointMake(0.5, 0.5);
            marker.userData=tempItem;
            if([tempItem isEqual:item]){
                [self.mapview setSelectedMarker:marker];
            }else{
                UIImage *dot=[UIImage imageNamed:@"hidden_marker.png"];
                marker.icon=[Util imageWithImage:dot scaledToSize:CGSizeMake(20, 20)];;
            }
            [self.arrMarker addObject:marker];
        }
    }
    [self.mapview setCamera:camera];
    [self.mapview setCamera:[self getNewDownABitOfCameraWithLat:item.lat lng:item.lng]];
    [[item.dicDetailPanel objectForKey:@"map"] addSubview:self.mapview];
    scrollViewList.scrollEnabled=NO;
}
-(GMSCameraPosition *)getNewDownABitOfCameraWithLat:(double) lat lng:(double)lng{
    CGPoint oriCenter=[self.mapview.projection pointForCoordinate:CLLocationCoordinate2DMake(lat,lng)];
    CGPoint destCenter=CGPointMake(oriCenter.x, oriCenter.y-80);
    CLLocationCoordinate2D destCoordinate=[self.mapview.projection coordinateForPoint:destCenter];
    GMSCameraPosition *destCamera = [GMSCameraPosition cameraWithLatitude:destCoordinate.latitude
                                                                longitude:destCoordinate.longitude
                                                                     zoom:15];
    return destCamera;
}

-(void)statusExpandToWithKeyboard:(ButtonComment *) btnCoextmment{
    if([GV getGlobalStatus]!=LIST_EXPAND){
        return;
    }
    [GV setGlobalStatus:LIST_EXPAND_WITHKEYBOARD];
}
-(void)statusWithKeyboardToExpand{
    if([GV getGlobalStatus]!=LIST_EXPAND_WITHKEYBOARD){
        return;
    }
    [GV setGlobalStatus:LIST_EXPAND];
}
-(void)statusToList{
    [GV setGlobalStatus:LIST];
}


-(CustomizeInfoWindow *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    for(int i =0;i<self.arrMarker.count;i++){
        if([self.arrMarker objectAtIndex:i]!=marker){
            UIImage *dot=[UIImage imageNamed:@"hidden_marker.png"];
            ((GMSMarker *)[self.arrMarker objectAtIndex:i]).icon=[Util imageWithImage:dot scaledToSize:CGSizeMake(20, 20)];;
        }
    }
    marker.icon=nil;
    [self.mapview setCamera:[self getNewDownABitOfCameraWithLat:marker.position.latitude lng:marker.position.longitude]];


    CustomizeMarker * newMarker=(CustomizeMarker *) marker;
    CustomizeInfoWindow *infoWindow=[[CustomizeInfoWindow alloc] initWithFrame: CGRectMake(0, 0, 200, 50)];
    infoWindow.lblName.text=newMarker.name;
    NSString *stringDist=@"";
    if(newMarker.distance>1000){
        stringDist=[NSString stringWithFormat:@"%.2f 公里",newMarker.distance/1000];
    }else{
        stringDist=[NSString stringWithFormat:@"%.0f 公尺",newMarker.distance];
    }
    infoWindow.lblDistance.text=[NSString stringWithFormat:@"距離: %@",stringDist];
    infoWindow.lblAddress.text=newMarker.address;
    
    [infoWindow initial];
    return infoWindow;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
        return YES;
}

@end
