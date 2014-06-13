//
//  AppDelegate.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerRoot.h"
#import "ViewTip.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "GV.h"
#import "KeyboardTopInput.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewControllerRoot *root;
@property (strong,nonatomic) ViewTip *tip;
@property KeyboardTopInput *keyboardTopInput;
@property (strong, nonatomic) FBSession *fbSession;
@property GV* gv;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
-(void)changeUILang;
-(void)iniConfig;
-(void) resizeView;
@end
