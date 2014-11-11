//
//  ViewPanelForLocation.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewPanelForLocation.h"
#import "Util.h"
#import "SliderDistance.h"
#import "DB.h"
#import "ScrollViewControllerCate.h"
#import "ScrollViewControllerList.h"
#import "ViewTip.h"
@implementation ViewPanelForLocation
@synthesize mapview,switchLocation,sliderDist,updateDBDistanceTimer,circle
,txtCenterAdderss,lblCenter,btnPin,viewBGForTxtCenterAddress;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        [locationManager startUpdatingLocation];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:locationManager.location.coordinate.latitude
                                                                longitude:locationManager.location.coordinate.longitude
                                                                     zoom:15];
        mapview = [GMSMapView mapWithFrame:CGRectMake(0, 110, self.gv.screenW, self.gv.screenH-40-80-110) camera:camera];
        mapview.myLocationEnabled = YES;
        mapview.accessibilityElementsHidden=NO;
        mapview.delegate=self;
        [mapview clear];
        [self addSubview:mapview];
        
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(0, 0);
        circle = [GMSCircle circleWithPosition:circleCenter
                                                 radius:300];
        circle.map=mapview;
        circle.fillColor = [Util colorWithHexString:@"b6e6e672"];
        circle.strokeColor = [Util colorWithHexString:@"#66abab72"];
        circle.zIndex=1;
        circle.strokeWidth = 1;

        GMSMutablePath *path = [GMSMutablePath path];

        [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2, mapview.frame.size.height/2-5)]];
        [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2, mapview.frame.size.height/2+5)]];
        self.centerCrossVertical = [GMSPolyline polylineWithPath:path];
        self.centerCrossVertical.strokeColor=[Util colorWithHexString:@"#263439FF"];
        self.centerCrossVertical.strokeWidth=0.5;
        self.centerCrossVertical.zIndex=2;
        self.centerCrossVertical.map=mapview;
        
        path = [GMSMutablePath path];
        [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2+5, mapview.frame.size.height/2)]];
        [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2-5, mapview.frame.size.height/2)]];
        self.centerCrosshorizontal = [GMSPolyline polylineWithPath:path];
        self.centerCrosshorizontal.strokeColor=[Util colorWithHexString:@"#263439FF"];
        self.centerCrosshorizontal.strokeWidth=0.5;
        self.centerCrosshorizontal.zIndex=2;
        self.centerCrosshorizontal.map=mapview;
        
        switchLocation=[[SwitchLocation alloc] initWithFrame:CGRectMake((self.gv.screenW-207)/2, 14, 207, 28)];
        [self addSubview:switchLocation];
        
        sliderDist =[[SliderDistance alloc]initWithFrame:CGRectMake((self.gv.screenW-207)/2, 65, 207, 28)];
        [sliderDist setTintColor:[Util colorWithHexString:@"#419291FF"]];
        [sliderDist setMinimumValue:0];
        [sliderDist setMaximumValue:100];
        [sliderDist addTarget:self
                      action:@selector(sliderChange:)
            forControlEvents:(UIControlEventValueChanged)];
        [sliderDist setMaximumTrackTintColor:[UIColor whiteColor]];
        [sliderDist setMinimumTrackTintColor:[Util colorWithHexString:@"#263439FF"]];
        self.lblDistance=[[UILabel alloc] initWithFrame:CGRectMake(130, 80, 200, 30)];
        [self.lblDistance setFont:self.gv.fontListFunctionTitle];
        [self.lblDistance setText:@"300 m"];
        [self addSubview:self.lblDistance];
        [self addSubview:sliderDist];
        
        viewBGForTxtCenterAddress=[[UIView alloc] initWithFrame:CGRectMake(0, mapview.frame.origin.y, self.gv.screenW, 45)];
        viewBGForTxtCenterAddress.userInteractionEnabled=NO;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = viewBGForTxtCenterAddress.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[Util colorWithHexString:@"#8fc9c8ff"] CGColor], (id)[[Util colorWithHexString:@"#8fc9c87f"] CGColor], nil];
        [viewBGForTxtCenterAddress.layer insertSublayer:gradient atIndex:0];
        [self addSubview:viewBGForTxtCenterAddress];
        [viewBGForTxtCenterAddress setAlpha:0.0];
        

        lblCenter=[[LabelForChangeUILang alloc]initWithFrame:CGRectMake(18, mapview.frame.origin.y+8, 50, 28)];
        [lblCenter setFont:self.gv.fontNormalForHebrew];
        [lblCenter setTextAlignment:NSTextAlignmentRight];
        [lblCenter setTextColor:[Util colorWithHexString:@"#263439FF"]];
        lblCenter.key=@"center";
        [lblCenter setHidden:YES];
        [lblCenter setAlpha:0.0f];
        [self addSubview:lblCenter];
        
        txtCenterAdderss=[[TextFieldCheckCoverOver alloc] initWithFrame:CGRectMake(lblCenter.frame.size.width+18+8, mapview.frame.origin.y+8, 180, 28)];
        [txtCenterAdderss setBackgroundColor:[Util colorWithHexString:@"#ffffffCC"]];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, txtCenterAdderss.frame.size.width, txtCenterAdderss.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){5, 5}].CGPath;
        txtCenterAdderss.layer.mask=maskLayer;
        [txtCenterAdderss setFont:self.gv.fontListFunctionTitle];
        [txtCenterAdderss setTextColor:[Util colorWithHexString:@"#263439FF"]];
        UIView *padding=[[UIView alloc] init];
        [padding setFrame:CGRectMake(0, 0, 10, 28)];
        txtCenterAdderss.leftView=padding;
        txtCenterAdderss.leftViewMode=UITextFieldViewModeAlways;
        [txtCenterAdderss setHidden:YES];
        [txtCenterAdderss setAlpha:0.0f];
        [self addSubview:txtCenterAdderss];
        

        btnPin=[[ButtonPin alloc] initWithFrame:CGRectMake(txtCenterAdderss.frame.origin.x+txtCenterAdderss.frame.size.width+5, txtCenterAdderss.frame.origin.y-8, 44, 44)];
        [self addSubview:btnPin ];
        [btnPin setAlpha:0.0f];
        [btnPin setHidden:YES];
    }
    return self;
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=(UITouch *)event.allTouches.anyObject;
    NSLog(@"list function bar:%@",NSStringFromClass(touch.view.class));
    [txtCenterAdderss resignFirstResponder];
    if ([touch.view isKindOfClass:[SwitchLocation class]]) {
        if(switchLocation.isOn){
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"list_other_center"];
            [self animationShowOtherCenter];
        }else{
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"list_current_center"];
            [self animationHideOtherCenter];
        }
        [self updateCameraCenterAndDB:YES];
    }else if([touch.view isKindOfClass:[ButtonPin class]]){
        [switchLocation turnOn:YES];
        if(txtCenterAdderss.text.length>0){
            [self convertAddressToCoordinate];
        }
    }
    [super touchesEnded:touches withEvent:event];
}

-(void) convertCoordinateToAddress{
    GMSGeocoder *geocoder=[[GMSGeocoder alloc] init];
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
    [geocoder reverseGeocodeCoordinate:selected.centerLocation completionHandler:^(GMSReverseGeocodeResponse *result, NSError *error) {
        if(error==nil){
            txtCenterAdderss.text=[result.firstResult.lines componentsJoinedByString:@","];
        }else{
            NSLog(@"convertCoordinateToAddress error:%@",error.description);
        }
    }];
}



-(void) convertAddressToCoordinate{
    NSString *url=[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=false",txtCenterAdderss.text];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:3 completion:^(NSMutableDictionary *data, NSError *connectionError) {

        if ([[data objectForKey:@"status"] isEqualToString:@"OK"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
                ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
                if([[data objectForKey:@"results"] count]>0){
                    NSDictionary *dicLocation=[[[[data objectForKey:@"results"] objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
                    CLLocationCoordinate2D tempLocation=CLLocationCoordinate2DMake([[dicLocation valueForKey:@"lat"] floatValue], [[dicLocation valueForKey:@"lng"] floatValue]);
                    selected.centerLocation=tempLocation;
                }else{
                    return;
                }
                [self updateCameraCenterAndDB:YES];
            });
        }else{
            NSLog(@"%@",[data objectForKey:@"status"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                ViewTip *tip=(ViewTip *)self.gv.viewTip;
                [tip statusPreviousStatusToTip:self title:[DB getUI:@"operation_hint"] msg:[DB getUI:@"cant_find_address"]];
            });
        }
    } queue:self.gv.backgroundThreadManagement];
}

-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    if(!switchLocation.isOn){
        [switchLocation turnOn:YES];
    }
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    scrollViewControllerCate.custCenterLocation = coordinate;
    [self.txtCenterAdderss resignFirstResponder];
    [self updateCameraCenterAndDB:YES];
    [self convertCoordinateToAddress];
}

-(void)animationShowOtherCenter{
    [lblCenter setHidden:NO];
    [txtCenterAdderss setHidden:NO];
    [btnPin setHidden:NO];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [lblCenter setAlpha:1.0f];
         [txtCenterAdderss setAlpha:1.0f];
         [btnPin setAlpha:1.0f];
         [viewBGForTxtCenterAddress setAlpha:1.0];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}
-(void)animationHideOtherCenter{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [lblCenter setAlpha:0.0f];
         [txtCenterAdderss setAlpha:0.0f];
         [btnPin setAlpha:0.0f];
         [viewBGForTxtCenterAddress setAlpha:0.0];
     } completion:^(BOOL finished) {
         if (finished){
             [lblCenter setHidden:YES];
             [txtCenterAdderss setHidden:YES];
             [btnPin setHidden:YES];
         }
     }];
}

- (void)sliderChange:(NSNotification *)notification {
    [updateDBDistanceTimer invalidate];
    updateDBDistanceTimer =nil;
    double tempDist=[self getDist];
    [circle setRadius:tempDist];
    double screenDist=[mapview.projection pointsForMeters:tempDist atCoordinate:circle.position];
    if(screenDist>self.gv.screenW/2){
        [mapview animateToZoom:mapview.camera.zoom-1];
    }else if(screenDist<40){
        [mapview animateToZoom:mapview.camera.zoom+1];
    }
    [self updateCenterCross:circle.position];
    if(tempDist>1000){
        tempDist=floor(tempDist*100/1000+0.5)/100;
        [self.lblDistance setText:[NSString stringWithFormat:@"%.2f km",tempDist]];
    }else{
        [self.lblDistance setText:[NSString stringWithFormat:@"%.0f m",tempDist]];
    }
    updateDBDistanceTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSelectedButtonCateDistanceAndDB) userInfo:nil repeats:NO];

}

-(void)zoomFit:(double)factDist centerLocation:(CLLocationCoordinate2D) centerLocation{


}

-(double)getDist{
    double tempResult=self.sliderDist.value;
    double a=1.055654553102258628588387749223;
    double b=77.541123059140389250715902339511;
    return floor((pow(a,b+tempResult))+0.5);
}

-(void)initialDistanceAndCenter:(ButtonCate *)selected{
    NSLog(@"initialDistanceAndCenter");
    if(selected==NULL){
        selected= [[ButtonCate alloc] init];
    }
    if(selected.distance<=0){
        selected.distance = 67;
    }
    double dist=selected.distance;
    double a=1.055654553102258628588387749223;
    double b=77.541123059140389250715902339511;
    double x=log10(dist)/log10(a)-b;
    [sliderDist setValue:x];
    if (x>=0){
        [circle setRadius:x];
    }
    [self sliderChange:nil];
    ScrollViewControllerCate *svCate = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    if(svCate.isCustLocation){
        [circle setPosition:selected.centerLocation];
        GMSCameraPosition *camera= [GMSCameraPosition cameraWithLatitude:selected.centerLocation.latitude
                                                               longitude:selected.centerLocation.longitude
                                                                    zoom:15];
        [mapview setCamera:camera];

        double screenRadius=[mapview.projection pointsForMeters:dist atCoordinate:selected.centerLocation];
        GMSCoordinateBounds *circleBound= [[GMSCoordinateBounds alloc]initWithCoordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2-screenRadius, self.mapview.frame.size.height/2)]
                    coordinate:[mapview.projection coordinateForPoint:CGPointMake(self.gv.screenW/2+screenRadius, self.mapview.frame.size.height/2)]];
       GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:circleBound withPadding:20];
        [mapview animateWithCameraUpdate:update];
        [switchLocation turnOn:NO];
        [self convertCoordinateToAddress];
    }else{
        [switchLocation turnOff:NO];
    }
}

-(void)updateSelectedButtonCateDistanceAndDB{
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    scrollViewControllerCate.selectedButtonCate.distance=[self getDist];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_updateDBCollectionDist:) object:[NSString stringWithFormat:@"%d",scrollViewControllerCate.selectedButtonCate.iden ]];
    [self.gv.FMDatabaseQueue addOperation:operation];
}

-(void)_updateDBCollectionDist:(NSString *)iden{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config set content='%.2f' WHERE name='distance'", [self getDist]]];
    [db close];
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    scrollViewControllerCate.custDist = [self getDist];
}

-(void) updateCameraCenterAndDB:(BOOL) isUpdateDB{
    NSLog(@"ViewPanelForLocation.updateCameraCenterAndDB");
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ScrollViewControllerList *scrollViewControllerList =(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
    NSMutableDictionary *dicParameter=[[NSMutableDictionary alloc] init];
    //center 是由外面傳進來的
    if(switchLocation.isOn){
        if(selected.centerLocation.latitude!=0 && selected.centerLocation.longitude!=0){
            [self updateCamera:selected.centerLocation];
            [dicParameter setValue:[NSString stringWithFormat:@"%f",selected.centerLocation.latitude] forKey:@"lat"];
            [dicParameter setValue:[NSString stringWithFormat:@"%f",selected.centerLocation.longitude] forKey:@"lng"];
        }else{
            selected.centerLocation = scrollViewControllerList.locationManager.location.coordinate;
        }
    }else{
        selected.centerLocation=CLLocationCoordinate2DMake(0, 0);
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        CLLocationCoordinate2D tempCenter = CLLocationCoordinate2DMake(locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
        [self updateCamera:tempCenter];
        [dicParameter setValue:@"0" forKey:@"lat"];
        [dicParameter setValue:@"0" forKey:@"lng"];
    }
    [dicParameter setValue:[NSString stringWithFormat:@"%d",selected.iden] forKey:@"id"];
    if(isUpdateDB){
        NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_updateDBCollectionCenter:) object:dicParameter];
        [self.gv.FMDatabaseQueue addOperation:operation];
    }
}

-(void) updateCamera:(CLLocationCoordinate2D)cameraCenter{
    GMSCameraPosition *camera=nil;
    camera= [GMSCameraPosition cameraWithLatitude:cameraCenter.latitude
                                        longitude:cameraCenter.longitude
                                             zoom:mapview.camera.zoom];
    [self updateCenterCross:cameraCenter];
    [circle setPosition:cameraCenter];
    [mapview setCamera:camera];
    
}

-(void) updateCenterCross:(CLLocationCoordinate2D) cameraCenter{
    self.centerCrossVertical.map=nil;
    self.centerCrosshorizontal.map=nil;
    self.centerCrosshorizontal=nil;
    self.centerCrossVertical=nil;
    
    GMSMutablePath *path = [GMSMutablePath path];
    CGPoint centerPoint=[mapview.projection pointForCoordinate:cameraCenter];
    [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(centerPoint.x+5, centerPoint.y)]];
    [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(centerPoint.x-5, centerPoint.y)]];
    self.centerCrosshorizontal = [GMSPolyline polylineWithPath:path];
    self.centerCrosshorizontal.strokeColor=[Util colorWithHexString:@"#263439FF"];
    self.centerCrosshorizontal.strokeWidth=0.5;
    self.centerCrosshorizontal.zIndex=2;
    self.centerCrosshorizontal.map=mapview;
    
    path = [GMSMutablePath path];
    [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(centerPoint.x, centerPoint.y+5)]];
    [path addCoordinate:[mapview.projection coordinateForPoint:CGPointMake(centerPoint.x, centerPoint.y-5)]];
    self.centerCrossVertical = [GMSPolyline polylineWithPath:path];
    self.centerCrossVertical.strokeColor=[Util colorWithHexString:@"#263439FF"];
    self.centerCrossVertical.strokeWidth=0.5;
    self.centerCrossVertical.zIndex=2;
    self.centerCrossVertical.map=mapview;

}

-(void)_updateDBCollectionCenter:(NSMutableDictionary *)dicParameters{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    NSLog(@"%@",[NSString stringWithFormat:@"UPDATE sys_config set content='%f' WHERE name='center_lat'",[[dicParameters valueForKey:@"lat"] floatValue]]);
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config set content='%f' WHERE name='center_lat'",[[dicParameters valueForKey:@"lat"] floatValue]]];
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config set content='%f' WHERE name='center_lng'",[[dicParameters valueForKey:@"lng"] floatValue]]];
    [db close];
}
@end
