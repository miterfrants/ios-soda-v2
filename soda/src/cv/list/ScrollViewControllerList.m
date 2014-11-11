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
#import "ButtonCate.h"
#import "ButtonInputForComment.h"
#import "ButtonExpand.h"
#import "CustomizeInfoWindow.h"
#import "ViewContainer.h"
#import "ViewControllerRoot.h"

@interface ScrollViewControllerList ()

@end

@implementation ScrollViewControllerList
@synthesize scrollViewList,gv,nextPageToken,locationManager,arrRadarResult,itemInstanceCreateCount,keyword,types,viewFunBar,arrItemList,isShowNoDataCate,isHidingNoDataCat;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.gv=[GV sharedInstance];
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate=self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([self.gv.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.gv.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        
        arrItemList=[[NSMutableArray alloc] init];
        
        scrollViewList=[[ScrollViewList alloc] initWithFrame:CGRectMake(0, 0, gv.screenW, gv.screenH-80)];
        [self.view addSubview:scrollViewList];
        scrollViewList.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.btnMore= [[ButtonMore alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        [self.btnMore setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];

        [self.btnMore setHidden:YES];
        [self.btnMore addTarget:self action:@selector(loadNextList) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollViewList addSubview:self.btnMore];
        
        

        self.loading=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake((self.gv.screenW-40)/2, (150-40)/2+40,40, 40)  thick:2];
        [self.view addSubview:self.loading];
        [self.loading setHidden:YES];
        
        isShowNoDataCate=NO;
        isHidingNoDataCat=NO;
        
        self.noDataCat=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lazy_cat.png"]];
        [self.noDataCat setFrame:CGRectMake((self.gv.screenW-self.noDataCat.frame.size.width/2)/2-40, 70, self.noDataCat.frame.size.width/2, self.noDataCat.frame.size.height/2)];
        [self.view addSubview:self.noDataCat];
        self.lblNoData=[[LabelForChangeUILang alloc]initWithFrame:CGRectMake(self.noDataCat.frame.size.width, self.noDataCat.frame.size.height-40, 140, 28)];
        [self.lblNoData setLineBreakMode:NSLineBreakByCharWrapping];
        [self.lblNoData setFont:self.gv.fontListFunctionTitle];
        [self.lblNoData setTextColor:[UIColor whiteColor]];
        self.lblNoData.key=@"no_data";
        [self.noDataCat addSubview:self.lblNoData];
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
        

        self.btnTakeMeThere =[[ButtonProtoType alloc] initWithFrame:CGRectMake((self.gv.screenW-44)/2, self.mapview.frame.size.height-44-10, 44, 44) ];
        self.btnTakeMeThere.viewBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_direction.png"]];
        self.btnTakeMeThere.iconOverNameForProtoType=@"circle_direction_over.png";
        self.btnTakeMeThere.iconNameForProtoType=@"circle_direction.png";
        [self.btnTakeMeThere.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        self.btnTakeMeThere.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.btnTakeMeThere.layer.shadowRadius = 5.0f;
        self.btnTakeMeThere.layer.shadowOpacity = .5f;
        self.btnTakeMeThere.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor
        ;
        [self.btnTakeMeThere addSubview:self.btnTakeMeThere.viewBg];
        [self.mapview addSubview:self.btnTakeMeThere];
        [self.btnTakeMeThere addTarget:self action:@selector(takeMeThere:) forControlEvents:UIControlEventTouchUpInside];
        
        arrRadarResult=[[NSArray alloc] init];
    }
    return self;
}

-(void)checkGPS{
    if ([[UIDevice currentDevice].systemVersion floatValue]>8) {
        if([CLLocationManager locationServicesEnabled]){
            if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized){
                NSLog(@"%@",@"kCLAuthorizationStatusAuthorized");
            }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
                NSLog(@"%@",@"kCLAuthorizationStatusAuthorizedAlways");
            }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
                NSLog(@"%@",@"kCLAuthorizationStatusAuthorizedWhenInUse");
            }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
                NSLog(@"kCLAuthorizationStatusDenied");
                self.lblNoData.key = @"please_eanble_gps";
            }else{
                NSLog(@"else");
                self.lblNoData.key = @"please_eanble_gps";
            }
        }else{
            self.lblNoData.key = @"please_eanble_gps";
        }
    }
}


-(void) takeMeThere:(ButtonProtoType *)sender{
     ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
    CLLocationCoordinate2D source=CLLocationCoordinate2DMake(selected.centerLocation.latitude, selected.centerLocation.longitude);
    if(source.latitude==0 && source.longitude==0){
        source=CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
    }
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        [UserInteractionLog sendAnalyticsEvent:@"tocuh" label:@"googel_map_direction_in_list"];
        NSString *url =[NSString stringWithFormat:@"comgooglemaps-x-callback://?saddr=%F,%F&daddr=%F,%F&directionsmode=walking&x-success=com.planb  .soda://?resume=true&x-source=soda",source.latitude,source.longitude,self.expandedItem.lat,self.expandedItem.lng];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[DB getUI:@"your_iphone_is_not_installed_google_map_yet"] message:@"" delegate:self cancelButtonTitle:[DB getUI:@"cancel_and_use_apple_map"] otherButtonTitles:[DB getUI:@"install_google_map"],nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",alertView);
    if (buttonIndex == 1) {
        [UserInteractionLog sendAnalyticsEvent:@"tocuh" label:@"apple_map_direction_in_list"];
        NSString *url =[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id585027354?mt=8"];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    } else {
        [UserInteractionLog sendAnalyticsEvent:@"tocuh" label:@"install_google_map_in_list"];
        ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
        ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
        CLLocationCoordinate2D source=CLLocationCoordinate2DMake(selected.centerLocation.latitude, selected.centerLocation.longitude);
        if(source.latitude==0 && source.longitude==0){
            source=CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude);
        }
        NSString *url=[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%F,%F&saddr=%F,%F",self.expandedItem.lat,self.expandedItem.lng,source.latitude,source.longitude];
        [[UIApplication sharedApplication] openURL:
         [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
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
    [oriItem.viewArrow setAlpha:0.0f];
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
            [item setFrame:CGRectMake(0, item.seq*150+40, self.gv.screenW, 150)];
        }
    }

    nextItem.expandName=@"map";
    nextItem.poseOfCurrentReview=0;
    [nextItem generateReview];
    [nextItem.viewArrow setAlpha:1.0f];
    [nextItem.viewArrow setFrame:CGRectMake(nextItem.btnShowMap.frame.origin.x+(nextItem.btnShowMap.frame.size.width-nextItem.viewArrow.frame.size.width)/2, nextItem.viewArrow.frame.origin.y, nextItem.viewArrow.frame.size.width, nextItem.viewArrow.frame.size.height)];
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
    [nextItem.contentCon setFrame:CGRectMake(0, 0, self.gv.screenW, self.gv.screenH-80)];
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
    [oriItem.viewArrow setAlpha:0.0];
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
            [item setFrame:CGRectMake(0, item.seq*150+40, self.gv.screenW, 150)];
        }
    }
    
    prevItem.expandName=@"map";
    prevItem.poseOfCurrentReview=0;
    [prevItem generateReview];
    [prevItem.viewArrow setAlpha:1.0];
    [prevItem.viewArrow setFrame:CGRectMake(prevItem.btnShowMap.frame.origin.x+(prevItem.btnShowMap.frame.size.width-prevItem.viewArrow.frame.size.width)/2, prevItem.viewArrow.frame.origin.y, prevItem.viewArrow.frame.size.width, prevItem.viewArrow.frame.size.height)];
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
    [prevItem.contentCon setFrame:CGRectMake(0, 0, self.gv.screenW, self.gv.screenH-80)];
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
     [self.loading stop];
    [viewFunBar.viewPanelForLocation.txtCenterAdderss stopObserver];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self.view setFrame:CGRectMake(self.view.frame.size.width, 80, self.view.frame.size.width, self.view.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished){
             //remove
             NSLog(@"clear and stop loading");
             [self clearList];

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
    [self.loading stop];
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
             ViewControllerRoot *rootVC =(ViewControllerRoot *) self.gv.viewControllerRoot;
             [self loadListAndInitWithKeyword:rootVC.viewControllerTop.txtSearch.text type:@"" dist:scrollViewControllerCate.custDist center:scrollViewControllerCate.custCenterLocation];
         }
     }];
}

-(void) loadListAndInitWithKeyword:(NSString *)pKeyword type:(NSString *) pType dist:(double)dist center:(CLLocationCoordinate2D) center{
    NSLog(@"%@",@"loadListWithKeyword");
    NSLog(@"distance:%f",dist);
    [self.scrollViewList setContentOffset:CGPointMake(0, 0)];
    [self.scrollViewList setContentSize:CGSizeMake(self.gv.screenW, 0)];
    [self.scrollViewList setScrollEnabled:YES];
    [self.scrollViewList setAlpha:0.0f];
    
    self.isLoadingList=YES;
    self.isPrepareDataEndOfItem=NO;
    self.isEndedForSearchResult=NO;
    self.isCancelCurrentLoadItemListMarker=NO;
    
    self.keyword=pKeyword;
    self.distance=dist;
    self.types=pType;

    self.itemPrepareDataCount=0;
    self.itemDisplayCount=0;  //for extra filter condition display
    self.totalIndex=0;
    self.targetIndex=0;
    self.checkedConditionCount=0;   //for extra filter condition logic

    self.arrItemList=[[NSMutableArray alloc] init];

    [self clearList];
    [self initialFunctionBarProperty];
    [self hideNoDataCat];
    
    [self.viewFunBar setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
    [self.loading stop];

    CLLocationCoordinate2D searchCenter;
    ScrollViewControllerCate *svCate= (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    if(svCate.isCustLocation){
        searchCenter=CLLocationCoordinate2DMake(center.latitude, center.longitude);
    }else{
        [locationManager startUpdatingLocation];
        searchCenter=CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
        if(searchCenter.longitude==0 && searchCenter.latitude == 0 ){
            [self checkGPS];
            [self showNoDataCat];
            return;
        }
    }
    

    
    //loading start then finish send request;
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
        //如果是local 然後又沒有rating key 和 condition 就把loading停掉
        if(arrFromLocal.count==0 && arrFromGoogle.count==0){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblNoData.key = @"no_data";
                [self showNoDataCat];
                [self.loading stop];
            });
            return;
        }else if(arrFromLocal.count<arrFromGoogle.count){
            self.arrRadarResult=arrFromGoogle;
        }else if(arrFromLocal.count>=arrFromGoogle.count){
            isFromLocal =YES;
            self.arrRadarResult=arrFromLocal;
        }
        
        if(![self isExistSortingKey] && ![self isExistfilterCondition] && !isFromLocal){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loading stop];
            });
        }
        
        self.totalIndex=(int) [arrRadarResult count]-1;
        self.startIndex=0;
        int maxLen=(int) [arrRadarResult count];

        if([self isExistSortingKey] || isFromLocal){
            self.isEndedForSearchResult=YES;
        }else{
            if(maxLen>self.gv.listBufferCount){
                maxLen=self.gv.listBufferCount;
            }else{
                self.isEndedForSearchResult=YES;
            }
        }
        if(maxLen>0){
            self.targetIndex=maxLen-1;
        }else{
            self.targetIndex=0;
        }
        
        BOOL isExistFilterCondition=[self isExistfilterCondition];
        BOOL isExistSortingKey=[self isExistSortingKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self initialViewWithBoolIsExistsSortingKey:isExistSortingKey isExistFilterCondition:isExistFilterCondition];
            [self createItemFromRadarResultWithIndex:0 isExistFilterCondition:isExistFilterCondition isExistSortingKey:isExistSortingKey isFromLocal:isFromLocal isSecondPage:NO];
        });
    } queue:self.gv.backgroundThreadManagement];
}

//initial btnMore scrollViewList
-(void)initialViewWithBoolIsExistsSortingKey:(BOOL) isExistSortingKey isExistFilterCondition:(BOOL)isExistFilterCondition{
    if(isExistSortingKey){
        [scrollViewList setAlpha:0.0f];
    }else{
        if(isExistFilterCondition){
            [scrollViewList setAlpha:0.0f];
        }else{
            [scrollViewList setAlpha:1.0f];
        }
    }

    if(!isExistFilterCondition){
        if(isExistSortingKey){
            [self.btnMore setAlpha:0.0f];
            [self.btnMore setHidden:YES];
            [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, [arrRadarResult count]*150)];
        }else{
            if(self.targetIndex<self.totalIndex){
                [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40+40)];
                [self.btnMore setFrame:CGRectMake(0, (self.targetIndex+1)*150+40, 320, 40)];
                [self.btnMore setHidden:NO];
                [self.btnMore setAlpha:1.0f];
            }else{
                [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40)];
                [self.btnMore setHidden:YES];
            }
        }
    }
}

-(NSDictionary *)getRadarPlaceFromGoogle:(CLLocationCoordinate2D) searchCenter dist:(double) dist pKeyword:(NSString*) pKeyword pType:(NSString *) pType {
    NSMutableString *nearbySearchURL=[[NSMutableString alloc] init];
    [nearbySearchURL appendFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%f,%f&radius=%f&keyword=%@&sensor=false&key=%@&rankBy=prominence&types=%@&language=%@",searchCenter.latitude,searchCenter.longitude,dist,[Util urlEncode:pKeyword],[GV sharedInstance].googleWebKey,pType, [Util langIOSCode:[DB getSysConfig:@"lang"]]];
    
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
-(void) createItemFromRadarResultWithIndex:(int) i isExistFilterCondition:(BOOL) isExistFilterCondition isExistSortingKey:(BOOL) isExistSortingKey isFromLocal:(BOOL) isFromLocal isSecondPage:(BOOL) isSecondPage{
    //如果當下的status 是cate就不繼續做下去
    if([GV getGlobalStatus]==COMMON){
        NSLog(@"exit createItemFromRadarResultWithIndex");
        return;
    }
    ListItem *item=[[ListItem alloc]init];
    
    //initial
    [item setFrame:CGRectMake(0, i*150+40, gv.screenW, 150)];
    //common status
    if(!isExistSortingKey && !isExistFilterCondition){
        item.isShow=YES;
        item.seq=i;
        [item.loadingCircle start];
        [scrollViewList addSubview:item];
        [item.contentCon setAlpha:0.0];
    //exist condition
    }else{
        item.seq=i;
        item.isShow=NO;
        if(isSecondPage){
            [item setAlpha:0.0];
        }else{
            [item.contentCon setAlpha:1.0];
        }
    }

    NSMutableDictionary *dicDataItem= [arrRadarResult objectAtIndex:i];
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
    itemInstanceCreateCount=i;
    
    //NSLog(@"create:%@",[NSString stringWithFormat:@"%d/%d",itemInstanceCreateCount,self.totalIndex]);
    
    if(itemInstanceCreateCount<self.targetIndex){
        [self createItemFromRadarResultWithIndex:itemInstanceCreateCount+1 isExistFilterCondition:isExistFilterCondition isExistSortingKey:isExistSortingKey isFromLocal:isFromLocal isSecondPage:isSecondPage];
    }else{
        NSLog(@"create item instance finish;");
        NSLog(@"finish and target index:%d",self.targetIndex);
        if(isFromLocal){
            [scrollViewList setAlpha:1.0];
            for(int i=self.startIndex;i<=self.arrRadarResult.count-1;i++){
                ListItem *currItem=(ListItem *)[arrItemList objectAtIndex:i];
                NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_initialItemDataAndThenForLocal:) object:currItem];
                [self.gv.backgroundThreadManagement addOperation:operation];
            }
        }else{
            for(int i=self.startIndex;i<=self.targetIndex;i++){
                ListItem *currItem=(ListItem *)[arrItemList objectAtIndex:i];
                [currItem addLoadGooglePlaceDetailToQueue:currItem.googleRef];
            }
        }
        //ScrollView Load NextPage marker;
        self.isLoadingList=NO;
    }
    
}

-(void)_initialItemDataAndThenForLocal:(ListItem *)item{
    [self initialItemDataAndThen:item isFromLocal:YES];
}
//from local data
//因為ListItem.initialItemData 是多執行緒所以裡頭沒辦法做item check;
-(void)initialItemDataAndThen:(ListItem*) item isFromLocal:(BOOL) isFromLocal{
    BOOL beShown=[item initialItemData:item.jsonBaseData isFromLocal:isFromLocal];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.checkedConditionCount+=1;
        if([self isExistSortingKey]){
            if(self.checkedConditionCount>=self.arrRadarResult.count){
                [self sortingAndFilterArrItemList];
                [self.loading stop];
            }
        }else{
            if(!beShown){
                [item removeFromSuperview];
                [item setHidden:YES];
                item.isShow=NO;
            }else{
                self.itemDisplayCount+=1;
                if([self isExistfilterCondition]){
                    item.seq=self.itemDisplayCount-1;
                }
                [self.btnMore setHidden:YES];
                [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, self.itemDisplayCount*150+40)];
                [item setAlpha:1.0f];
                item.isShow=YES;
            }
            int checkMax=(int)self.arrRadarResult.count-1;
            if(!isFromLocal){
                checkMax=self.targetIndex;
            }
            if(self.checkedConditionCount>checkMax){
                //finish check condition;
                if(!isFromLocal){
                    double moreButtonOffset =0;
                    if(!self.isEndedForSearchResult){
                        NSLog(@"not end for serach: %d",self.itemDisplayCount);
                        moreButtonOffset=40;
                        [self.btnMore setAlpha:0.0];
                        [self.btnMore setHidden:NO];
                        [self.btnMore setFrame:CGRectMake(0,self.itemDisplayCount*150+40, self.gv.screenW, 40)];
                    }else{
                        [self.btnMore setHidden:YES];
                    }
                }else{
                    [self.btnMore setHidden:YES];
                }
                [self.loading stop];
                if(self.itemDisplayCount==0){
                    [self showNoDataCat];
                    return;
                }
                [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if(!self.btnMore.isHidden){
                        [self.btnMore setAlpha:1.0];
                        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, self.itemDisplayCount*150+40+40)];
                        [self.btnMore.lblTitle setTextColor:[UIColor whiteColor]];
                    }else{
                        [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, self.itemDisplayCount*150+40)];
                    }
                    [scrollViewList setAlpha:1.0f];
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
        [item.loadingCircle stop];
        [item placeElement];
        [item displaySelf];
    });
}

-(int) getListItemCountInnerScrollViewList{
    int result=0;
    NSArray *subviews=scrollViewList.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[ListItem class]]){
            result+=1;
        }
    }
    return result;
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
    if(sort){
        [arrItemList sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
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
        self.itemDisplayCount+=1;
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

-(void)loadNextList{
    if(self.isEndedForSearchResult){
        return;
    }
    if(self.isLoadingList){
        return;
    }
    int maxLen=(int)self.arrRadarResult.count;
    if(maxLen>itemInstanceCreateCount+self.gv.listBufferCount+1){
        maxLen=itemInstanceCreateCount+self.gv.listBufferCount+1;
    }else{
        self.isEndedForSearchResult=YES;
    }

    if(maxLen>0){
        self.targetIndex=maxLen-1;
    }else{
        self.targetIndex=0;
    }
    self.startIndex=itemInstanceCreateCount+1;
    //self.itemAccmulatingLoadCount=self.itemDisplayCount;
    NSLog(@"page:%d",itemInstanceCreateCount+self.gv.listBufferCount);
    NSLog(@"targetIndex:%d",self.targetIndex);

    
    self.isLoadingList=YES;

    if([self isExistfilterCondition]){
        [self.loading start];
        [self.loading setHidden:NO];
        [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.loading setAlpha:1.0f];
            [self.btnMore.lblTitle setTextColor:[Util colorWithHexString:@"#8fc9c8ff"]];
        } completion:^(BOOL finished) {
        }];
    }else{
        if(self.targetIndex<self.totalIndex){
            [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40+40   )];
            [self.btnMore setFrame:CGRectMake(0, (self.targetIndex+1)*150+40, 320, 40)];
            [self.btnMore setHidden:NO];
        }else{
            [scrollViewList setContentSize:CGSizeMake(self.gv.screenW, (self.targetIndex+1)*150+40)];
            [self.btnMore setHidden:YES];
        }
    }
    [self createItemFromRadarResultWithIndex:self.itemInstanceCreateCount+1 isExistFilterCondition:[self isExistfilterCondition] isExistSortingKey:[self isExistSortingKey] isFromLocal:NO isSecondPage:YES];
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
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:[NSString stringWithFormat:@"expand_detail_place_%@",btnExpand.name]];
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
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:[NSString stringWithFormat:@"contract_detail_place_%@",btnExpand.name]];
        }else{
            [self slideToOtherExpandWitItem:item willExpandDetailName:btnExpand.name];
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:[NSString stringWithFormat:@"slide_detail_place_%@",btnExpand.name]];
        }
    }else if([GV getGlobalStatus]==LIST_EXPAND && [touch.view isKindOfClass:[ViewContainer class]] ){
        ListItem* item=(ListItem*)touch.view.superview;
        [self statusExpandToList:item];
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"contract_detail_place"];
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
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"call_in_detail"];
        ListItem *item=(ListItem *) touch.view.superview.superview;
        [item call];
    }else if([GV getGlobalStatus]==LIST && [touch.view isKindOfClass:[ButtonFunction class]]){
        NSLog(@"list condition 6: 切換搜尋設定");
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"expand_list_config"];
        [viewFunBar switchViewPanelWithTargetButton:(ButtonFunction *)touch.view];
    }else if([touch.view isKindOfClass:[ButtonSaveReview class]] && [GV getGlobalStatus]== LIST_EXPAND){
        NSLog(@"list condition 7: 存review");
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"save_review"];
        ListItem *item=(ListItem *) touch.view.superview.superview.superview;
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
            [item.viewArrow setFrame:CGRectMake(item.btnShowMap.frame.origin.x+(item.btnShowMap.frame.size.width-item.viewArrow.frame.size.width)/2, item.viewArrow.frame.origin.y, item.viewArrow.frame.size.width, item.viewArrow.frame.size.height)];

            [item.lblIForComment setFrame:CGRectMake(self.gv.screenW+item.lblIForComment.frame.origin.x, item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
            [item.btnComment setFrame:CGRectMake(self.gv.screenW+item.btnComment.frame.origin.x, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
        }else if([willExpandDetailName isEqual:@"review"]){
           [item.viewArrow setFrame:CGRectMake(item.btnReview.frame.origin.x+(item.btnReview.frame.size.width-item.viewArrow.frame.size.width)/2, item.viewArrow.frame.origin.y, item.viewArrow.frame.size.width, item.viewArrow.frame.size.height)];
            
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
    //on:other off:current
    [self.mapview clear];
//    GMSCircle *circle=[[GMSCircle alloc]init];
//    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
//    [circle setPosition:scrollViewControllerCate.selectedButtonCate.centerLocation];
//    [circle setRadius:scrollViewControllerCate.selectedButtonCate.distance];
//    circle.fillColor = [Util colorWithHexString:@"b6e6e672"];
//    circle.strokeColor = [Util colorWithHexString:@"#66abab72"];
//    circle.zIndex=1;
//    circle.strokeWidth = 1;
//    circle.map=self.mapview;
    
    //沒有中心點用 current location
//    if(scrollViewControllerCate.selectedButtonCate.centerLocation.latitude==0 &&
//       scrollViewControllerCate.selectedButtonCate.centerLocation.longitude==0){
//        [circle setPosition:CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude)];
//    }
    
    
//    [self.mapview clear];
    self.arrMarker =[[NSMutableArray alloc]init];
    NSArray *subviews =self.scrollViewList.subviews;
    NSMutableArray *sortinListItem=[[NSMutableArray alloc]init];
    for(int i=0;i<subviews.count;i++){
        if(![[subviews objectAtIndex:i] isKindOfClass:[ListItem class]]){
            continue;
        }
        ListItem *item=(ListItem *)[subviews objectAtIndex:i];
        if(item.isShow){
            [sortinListItem addObject:[subviews objectAtIndex:i]];
        }
    }
    
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"seq" ascending:YES];
    [sortinListItem sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    for(int i=0;i<sortinListItem.count;i++){
        ListItem *tempItem=(ListItem *)[sortinListItem objectAtIndex:i];
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
                self.selectedMarker=marker;
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
    CGPoint destCenter=CGPointMake(oriCenter.x, oriCenter.y-self.gv.screenH*0.1482);
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
        stringDist=[NSString stringWithFormat:@"%.2f km",newMarker.distance/1000];
    }else{
        stringDist=[NSString stringWithFormat:@"%.0f m",newMarker.distance];
    }
    infoWindow.lblDistance.text=[NSString stringWithFormat:@"%@: %@", [DB getUI:@"distance"],stringDist];
    infoWindow.lblAddress.text=newMarker.address;
    
    [infoWindow initial];
    return infoWindow;
}
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker{
    if([marker isEqual:self.selectedMarker]){
        [self.mapview setSelectedMarker:self.selectedMarker];
    }
    return YES;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:manager.location.coordinate.latitude
                                                            longitude:manager.location.coordinate.longitude
                                                                 zoom:self.viewFunBar.viewPanelForLocation.mapview.camera.zoom];
    //update selected cate center
    ScrollViewControllerCate *sv = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    sv.custCenterLocation = manager.location.coordinate;
    [self.viewFunBar.viewPanelForLocation.mapview setCamera:camera];
    [self.viewFunBar.viewPanelForLocation.circle setPosition:CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude)];
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
}

@end
