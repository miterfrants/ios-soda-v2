//
//  ViewTip.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GV.h"
@interface ViewTip : UIView
@property UIView *viewArrowBorder;
@property UILabel *lblTitle;
@property UILabel *lblMsg;
@property UIView *viewBorder;
@property double originY;
@property id targetRef;
@property GV *gv;
-(void) addArrowBorder;
-(void)statusPreviousStatusToTip:(UIView *)target title:(NSString*)title msg:(NSString*)msg;
-(void)statusTipToPreviousStatus;
@end
