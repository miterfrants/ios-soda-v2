//
//  ButtonProtoType.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GV.h"

@interface ButtonProtoType : UIButton
@property BOOL isCanceled;
@property NSTimer *highlightTimer;
@property GV *gv;
@property UIImageView *viewBg;
@property NSString *iconNameForProtoType;
@property NSString *iconOverNameForProtoType;
@end
