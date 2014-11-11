//
//  ViewPanelForLocation.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import "SwitchLocation.h"
#import "SliderDistance.h"
#import "ButtonPin.h"
#import "ButtonCate.h"
#import "TextFieldCheckCoverOver.h"
#import "LabelForChangeUILang.h"
@interface ViewPanelForLocation : ViewProtoType<GMSMapViewDelegate>
@property SliderDistance *sliderDist;
@property SwitchLocation *switchLocation;
@property UILabel *lblDistance;
@property (nonatomic,strong) GMSMapView *mapview;
@property NSTimer *updateDBDistanceTimer;
@property GMSCircle *circle;
@property TextFieldCheckCoverOver *txtCenterAdderss;
@property UIView *viewBGForTxtCenterAddress;
@property LabelForChangeUILang *lblCenter;
@property ButtonPin *btnPin;
@property UIView *viewCross;
@property GMSPolyline *centerCrossVertical;
@property GMSPolyline *centerCrosshorizontal;

-(void) updateCameraCenterAndDB:(BOOL) isUpdateDB;
-(void) updateCamera:(CLLocationCoordinate2D)cameraCenter;
-(void)initialDistanceAndCenter:(ButtonCate *)selected;
-(void)animationShowOtherCenter;
-(void)animationHideOtherCenter;
-(void) stopUpdateLocationUpdate;

@end
