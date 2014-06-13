//
//  CustomizeMarker.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/3.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@interface CustomizeMarker : GMSMarker
@property NSString *address;
@property NSString *name;
@property double distance;
@property int markerSeq;
@end
