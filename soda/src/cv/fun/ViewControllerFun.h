//
//  ViewControllerFun.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerProtoType.h"
#import "ViewMenu.h"
#import "ButtonGear.h"

@interface ViewControllerFun : ViewControllerProtoType 
@property ButtonGear *btnGear;
@property ViewMenu *viewMenu;
@property NSMutableArray *arrSecretIcon;
-(void)statusMenuToPreviousStatus;
-(void)statusCurrentToMenu;
-(void) changeToLoginStatus;
-(void) changeToUnloginStatus;
@end
