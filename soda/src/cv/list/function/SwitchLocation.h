//
//  SwitchLocation.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewProtoType.h"

@interface SwitchLocation : ViewProtoType
@property UILabel *lblOn;
@property UILabel *lblOff;
@property UIView *viewButton;
@property UIView *viewBorder;
@property CAShapeLayer *layerBg;
@property BOOL isOn;
-(void) turnOn:(BOOL) animation;
-(void) turnOff:(BOOL) animation;
@end
