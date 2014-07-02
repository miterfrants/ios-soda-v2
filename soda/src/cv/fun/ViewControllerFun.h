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
#import <MessageUI/MessageUI.h>

@interface ViewControllerFun : ViewControllerProtoType <MFMailComposeViewControllerDelegate>
@property ButtonGear *btnGear;
@property ViewMenu *viewMenu;
@property NSMutableArray *arrSecretIcon;
@property MFMailComposeViewController *mail;
-(void)statusMenuToPreviousStatus;
-(void)statusCurrentToMenu;
-(void)changeToLoginStatus;
-(void)changeToUnloginStatus;
-(void)sendMail;
@end
