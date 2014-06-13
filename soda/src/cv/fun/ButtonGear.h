//
//  ButtonGear.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"
#import "BUttonGear.h"
@interface ButtonGear : ButtonProtoType
@property GV *gv;
@property UIView *viewBorder;
@property UIView *viewShadow;
-(void)changeToLoginView;
-(void)changeToUnloginView;
@end
