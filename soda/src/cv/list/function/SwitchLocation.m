//
//  SwitchLocation.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "SwitchLocation.h"
#import "GV.h"
#import "Util.h"
#import "ViewPanelForLocation.h"
#import "ScrollViewControllerCate.h"
#import "ScrollViewControllerList.h"
#import "DB.h"

@implementation SwitchLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isOn=NO;
        self.viewBorder=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width+2, frame.size.height+2)];
        self.layerBg=[CAShapeLayer layer];
        UIBezierPath *pathBorder=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width+2, frame.size.height+2) byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){(frame.size.height+2)/2, (frame.size.height+2)/2}];
        self.layerBg.lineWidth=2.0f;
        self.layerBg.strokeColor=[Util colorWithHexString:@"#d7d7d7FF"].CGColor;
        self.layerBg.path=pathBorder.CGPath;
        self.layerBg.fillColor=[UIColor whiteColor].CGColor;
        [self.viewBorder.layer addSublayer:self.layerBg];
        self.viewBorder.userInteractionEnabled=NO;
        [self addSubview:self.viewBorder];
        
        
        self.viewButton=[[UIView alloc] initWithFrame:CGRectMake(1, 1, frame.size.width/2, frame.size.height)];
        self.viewButton.userInteractionEnabled=NO;
        CAShapeLayer *layerButton=[CAShapeLayer layer];
        UIBezierPath *pathButton=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width/2, frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){frame.size.height/2, frame.size.height/2}];
        layerButton.path=pathButton.CGPath;
        layerButton.strokeColor=[Util colorWithHexString:@"#e1e1e1FF"].CGColor;
        layerButton.fillColor=[UIColor whiteColor].CGColor;
        [self.viewButton.layer addSublayer:layerButton];
        [self addSubview:self.viewButton];
        self.viewButton.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
        self.viewButton.layer.shadowRadius = 2.0f;
        self.viewButton.layer.shadowOpacity = .7f;
        self.viewButton.layer.shadowColor = [Util colorWithHexString:@"#CCCCCCff"].CGColor
        ;
        
        self.lblOff=[[LabelForChangeUILang alloc] initWithFrame:CGRectMake(0, 0, 100, 28)];
        [self.lblOff setTextAlignment:NSTextAlignmentCenter];
        [self.lblOff setFont:[GV sharedInstance].fontListFunctionTitle];
        [self.lblOff setTextColor:[Util colorWithHexString:@"#263439FF"]];
        self.lblOff.key=@"current";
        
        self.lblOn=[[LabelForChangeUILang alloc] initWithFrame:CGRectMake(100, 0, 100, 28)];
        [self.lblOn setTextAlignment:NSTextAlignmentCenter];
        [self.lblOn setFont:[GV sharedInstance].fontListFunctionTitle];
        [self.lblOn setTextColor:[Util colorWithHexString:@"66acabff"]];
        self.lblOn.key=@"other";
        [self addSubview:self.lblOff];
        [self addSubview:self.lblOn];
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isOn){
        [self turnOff:YES];
    }else{
        [self turnOn:YES];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void) turnOn:(BOOL) animation{
     self.isOn=YES;
    [DB setSysConfig:@"is_cust_location" value:@"Y"];
    ViewPanelForLocation *supercon=(ViewPanelForLocation *)[self superview];
    ScrollViewControllerList *svList= (ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    [svList.locationManager stopUpdatingLocation];
    ScrollViewControllerCate *svCate= (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    svCate.isCustLocation=YES;
    [supercon animationShowOtherCenter];

    if(animation){
        [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [self.viewButton setFrame:CGRectMake(104, 1, self.frame.size.width, self.frame.size.height)];
             [self.lblOn setTextColor:[Util colorWithHexString:@"#263439FF"]];
             [self.lblOff setTextColor:[Util colorWithHexString:@"#66acabff"]];
             [self.layerBg setFillColor:[Util colorWithHexString:@"#419291FF"].CGColor];
             [self.layerBg setStrokeColor:[Util colorWithHexString:@"#419291FF"].CGColor];

         } completion:^(BOOL finished) {
             
         }];        
    }else{
        [self.viewButton setFrame:CGRectMake(104, 1, self.frame.size.width, self.frame.size.height)];
        [self.lblOn setTextColor:[Util colorWithHexString:@"#263439FF"]];
        [self.lblOff setTextColor:[Util colorWithHexString:@"#66acabff"]];
        [self.layerBg setFillColor:[Util colorWithHexString:@"#419291FF"].CGColor];
        [self.layerBg setStrokeColor:[Util colorWithHexString:@"#419291FF"].CGColor];
    }
}
-(void) turnOff:(BOOL) animation{
     self.isOn=NO;
    ScrollViewControllerList *svList= (ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    [DB setSysConfig:@"is_cust_location" value:@"N"];
    [svList.locationManager startUpdatingLocation];
    ViewPanelForLocation *supercon=(ViewPanelForLocation *)[self superview];
    ScrollViewControllerCate *svCate= (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    svCate.isCustLocation=NO;
    [supercon animationHideOtherCenter];
    
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    CLLocationCoordinate2D tempCenter = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    selected.centerLocation=tempCenter;
    
    
    if(animation){
        [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [self.viewButton setFrame:CGRectMake(1, 1, self.frame.size.width, self.frame.size.height)];
             [self.lblOn setTextColor:[Util colorWithHexString:@"#66acabff"]];
             [self.lblOff setTextColor:[Util colorWithHexString:@"#263439FF"]];
             [self.layerBg setFillColor:[Util colorWithHexString:@"#FFFFFFFF"].CGColor];
             [self.layerBg setStrokeColor:[Util colorWithHexString:@"#e1e1e1FF"].CGColor];
         } completion:^(BOOL finished) {
             if(finished){
                 
             }
         }];
    }else{
        [self.viewButton setFrame:CGRectMake(1, 1, self.frame.size.width, self.frame.size.height)];
        [self.lblOn setTextColor:[Util colorWithHexString:@"#66acabff"]];
        [self.lblOff setTextColor:[Util colorWithHexString:@"#263439FF"]];
        [self.layerBg setFillColor:[Util colorWithHexString:@"#FFFFFFFF"].CGColor];
        [self.layerBg setStrokeColor:[Util colorWithHexString:@"#e1e1e1FF"].CGColor];
    }
}

@end
