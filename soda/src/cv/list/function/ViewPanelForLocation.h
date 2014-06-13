//
//  ViewPanelForLocation.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SwitchLocation.h"
#import "SliderDistance.h"
#import "ButtonPin.h"
#import "ButtonCate.h"
#import "TextFieldCheckCoverOver.h"

@interface ViewPanelForLocation : ViewProtoType<GMSMapViewDelegate>
@property SliderDistance *sliderDist;
@property SwitchLocation *switchLocation;
@property UILabel *lblDistance;
@property (nonatomic,strong) GMSMapView *mapview;
@property NSTimer *updateDBDistanceTimer;
@property GMSCircle *circle;
@property TextFieldCheckCoverOver *txtCenterAdderss;
@property UIView *viewBGForTxtCenterAddress;
@property UILabel *lblCenter;
@property ButtonPin *btnPin;
-(void) updateCameraCenterAndDB;
-(void) updateCamera:(CLLocationCoordinate2D)cameraCenter;
-(void)initialDistanceAndCenter:(ButtonCate *)selected;
-(void)animationShowOtherCenter;
-(void)animationHideOtherCenter;

@end
