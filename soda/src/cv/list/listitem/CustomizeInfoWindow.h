//
//  CustomizeInfoWindow.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/3.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"

@interface CustomizeInfoWindow : ViewProtoType
@property UILabel *lblName;
@property UILabel *lblAddress;
@property UILabel *lblDistance;
-(void) initial;
@end
