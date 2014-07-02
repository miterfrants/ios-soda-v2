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

        [self addSubview:mapview];
        
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(0, 0);
        circle = [GMSCircle circleWithPosition:circleCenter
                                                 radius:300];
        circle.map=mapview;
        circle.fillColor = [Util colorWithHexString:@"b6e6e672"];
        circle.strokeColor = [Util colorWithHexString:@"#66abab72"];
        circle.strokeWidth = 3;
        
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
        gradient.colors = [NSArray arrayWithObjects:(id)[[Util colorWithHexString:@"8fc9c8ff"] CGColor], (id)[[Util colorWithHexString:@"8fc9c87f"] CGColor], nil];
        [viewBGForTxtCenterAddress.layer insertSublayer:gradient atIndex:0];
        [self addSubview:viewBGForTxtCenterAddress];
        [viewBGForTxtCenterAddress setAlpha:0.0];
        
        CGSize fontSize=[@"Center:" sizeWithAttributes:@{NSFontAttributeName:self.gv.fontListFunctionTitle }];
        lblCenter=[[UILabel alloc]initWithFrame:CGRectMake(18, mapview.frame.origin.y+8, fontSize.width, 28)];
        [lblCenter setFont:self.gv.fontListFunctionTitle];
        [lblCenter setTextColor:[UIColor whiteColor]];
        [lblCenter setText:@"Center:"];
//        lblCenter.layer.shadowOffset = CGSizeMake(0.0f,0.0f);
//        lblCenter.layer.shadowRadius = 2.0f;
//        lblCenter.layer.shadowOpacity = .8f;
//        lblCenter.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor;
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
            [self animationShowOtherCenter];
        }else{
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
                    NSLog(@"%f",selected.centerLocation.longitude);
                }else{
                    return;
                }
                [self updateCameraCenterAndDB:YES];
            });
        }else{
            NSLog(@"ZERO_RESULTS");
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
    ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
    selected.centerLocation=coordinate;
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
    if(tempDist>1000){
        tempDist=floor(tempDist*100/1000+0.5)/100;
        [self.lblDistance setText:[NSString stringWithFormat:@"%.2f km",tempDist]];
    }else{
        [self.lblDistance setText:[NSString stringWithFormat:@"%.0f m",tempDist]];
    }
    updateDBDistanceTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSelectedButtonCateDistanceAndDB) userInfo:nil repeats:NO];

}

-(double)getDist{
    double tempResult=self.sliderDist.value;
    double a=1.055654553102258628588387749223;
    double b=77.541123059140389250715902339511;
    return floor((pow(a,b+tempResult))+0.5);
}

-(void)initialDistanceAndCenter:(ButtonCate *)selected{
    double dist=selected.distance;
    double a=1.055654553102258628588387749223;
    double b=77.541123059140389250715902339511;
    double x=log10(dist)/log10(a)-b;
    [sliderDist setValue:x];
    [circle setRadius:x];
    [self sliderChange:nil];
    if(selected.centerLocation.latitude!=0 && selected.centerLocation.longitude!=0){
        [circle setPosition:selected.centerLocation];
        GMSCameraPosition *camera= [GMSCameraPosition cameraWithLatitude:selected.centerLocation.latitude
                                                               longitude:selected.centerLocation.longitude
                                                                    zoom:15];
        [mapview setCamera:camera];
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
    NSLog(@"%@",[NSString stringWithFormat:@"UPDATE collection set distance='%.2f' WHERE id=%d", [self getDist],[iden intValue]]);
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection set distance='%.2f' WHERE id=%d", [self getDist],[iden intValue]]];
    [db close];
}

-(void) updateCameraCenterAndDB:(BOOL) isUpdateDB{
    NSLog(@"ViewPanelForLocation.updateCameraCenterAndDB");
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected =scrollViewControllerCate.selectedButtonCate;
    NSMutableDictionary *dicParameter=[[NSMutableDictionary alloc] init];
    //center 是由外面傳進來的
    if(switchLocation.isOn){
        [self updateCamera:selected.centerLocation];
        [dicParameter setValue:[NSString stringWithFormat:@"%f",selected.centerLocation.latitude] forKey:@"lat"];
        [dicParameter setValue:[NSString stringWithFormat:@"%f",selected.centerLocation.longitude] forKey:@"lng"];
    }else{
        CLLocationManager *locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
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
    NSLog(@"cameraCenter:%f",cameraCenter.latitude);
    [circle setPosition:cameraCenter];
    [mapview setCamera:camera];
}

-(void)_updateDBCollectionCenter:(NSMutableDictionary *)dicParameters{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    NSLog(@"%@",[NSString stringWithFormat:@"UPDATE collection set center_lat='%f',center_lng='%f' WHERE id=%d",[[dicParameters valueForKey:@"lat"] floatValue],[[dicParameters valueForKey:@"lng"] floatValue]  ,[[dicParameters valueForKey:@"id"] intValue]]);
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection set center_lat='%f',center_lng='%f' WHERE id=%d",[[dicParameters valueForKey:@"lat"] floatValue],[[dicParameters valueForKey:@"lng"] floatValue]  ,[[dicParameters valueForKey:@"id"] intValue]]];
    [db close];
}
@end
