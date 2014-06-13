//
//  ViewControllerFun.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewControllerFun.h"
#import "Util.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ButtonFb.h"
#import "ButtonLogout.h"
#import "ButtonSendSuggestion.h"
#import "SwitchProfile.h"
#import "DB.h"
#import "SecretIcon.h"
#import "ButtonSecretIcon.h"
#import "ViewExpandedPanel.h"

@interface ViewControllerFun ()

@end

@implementation ViewControllerFun
@synthesize btnGear,viewMenu,gv,arrSecretIcon;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        viewMenu=[[ViewMenu alloc]init];
        [viewMenu setBackgroundColor:[Util colorWithHexString:@"#8dc7c6F2"]];
        //[viewMenu setBackgroundColor:[Util colorWithHexString:@"#FF0000CC"]];
        [self.view addSubview:viewMenu];
        
        //[self.view setBackgroundColor:[Util colorWithHexString:@"#0000FFCC"]];
        btnGear=[[ButtonGear alloc] initWithFrame:CGRectMake(7.5, 27, 44, 44)];
        [self.view addSubview:btnGear];
        
        [self resetViewFunSize];
        //[self.view setBackgroundColor:[UIColor redColor]];
        
        //keyboard observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        //profile switch change
        [viewMenu.viewProfile.switchNotificationForDiscover addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewProfile.switchOperatingTip addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewProfile.switchShareFavoriteToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewProfile.switchShareGoodToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewProfile.switchShareIconToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *lang=[DB getSysConfig:@"lang"];
    NSArray *keys=gv.dicLang.allKeys;
    for(int i =0;i<keys.count;i++){
        if([[keys objectAtIndex:i] isEqual:lang]){
            [viewMenu.viewConfig.pickLang selectRow:i inComponent:0 animated:NO];
        }
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches] anyObject];
    NSLog(@"fun:%@",NSStringFromClass(touch.view.class));

    if([GV getGlobalStatus]==MENU && [touch.view isKindOfClass:ButtonFb.class]){
        [self loginByFb];
    }else if([GV getGlobalStatus]==MENU &&[touch.view isKindOfClass:ButtonGoogle.class]){
        [self loginByGoogle];
    }else if([GV getGlobalStatus]==MENU && [touch.view isMemberOfClass:[ButtonMenu class]]){
        ButtonMenu *btn=(ButtonMenu *) touch.view;
        [self animationExpand:btn.name];
    }else if([GV getGlobalStatus]==MENU && [touch.view isMemberOfClass:[ButtonReset class]]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Reset"
                              message:@"Confirm to abort all personal setting?"
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes",nil];
        [alert show];
    }else if([GV getGlobalStatus]==MENU && [touch.view isMemberOfClass:[ButtonForPersonal class]]){
        ButtonForPersonal *btn=(ButtonForPersonal *) touch.view;
        [self animationExpand:btn.name];
    }else if([GV getGlobalStatus]==COMMON){
        [self.view.superview bringSubviewToFront:self.view];
        [self statusCurrentToMenu];
    }else if([GV getGlobalStatus]==LIST){
        [self.view.superview bringSubviewToFront:self.view];
        [self statusCurrentToMenu];
    }else if([touch.view isKindOfClass:[ButtonLogout class]]){
        [self logout];
    }else if([touch.view isKindOfClass:[ButtonSendSuggestion class]]){
        [self sendSuggestion:viewMenu.viewSuggestion.txtComment.text];
    }else{
        [self.viewMenu.viewSuggestion.txtComment resignFirstResponder];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)keyboardWillShow:(NSNotification *)note{
    if([GV getGlobalStatus]==MENU){
        CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
        [self animationShrinkSuggestionWithKeyboardSize:keyboardSize duraction:duration curve:curve];
    }
}

- (void)keyboardWillHide:(NSNotification*)note
{
    if([GV getGlobalStatus]==MENU){
        CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
        [self animationExpandSuggestionWithKeyboardSize:keyboardSize duraction:duration curve:curve];
    }
}
-(void) statusCurrentToMenu{
    if([GV getGlobalStatus]==EDIT_WITH_KEYBOARD || [GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD){
        return;
    }
    [GV sharedInstance].previousStatusForMenu=[GV getGlobalStatus];
    [self iniViewFunSize];
    [self animationSlideMenu];
    [GV setGlobalStatus:MENU];
}
-(void) statusMenuToPreviousStatus{
    if([GV getGlobalStatus]==EDIT_WITH_KEYBOARD || [GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD){
        return;
    }
    [self resetViewFunSize];
    [self animationSlideOutMenu];
    [GV setGlobalStatus:[GV sharedInstance].previousStatusForMenu];
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",alertView);
    if (buttonIndex == 1) {
        NSLog(@"YES, reset");
        AppDelegate *app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *keys=gv.dicLang.allKeys;
        for(int i=0;i<keys.count;i++){
            if([[keys objectAtIndex:i] isEqualToString:[Util getLang]]){
                [viewMenu.viewConfig.pickLang selectRow:i inComponent:0 animated:YES];
            }
        }
        [DB dropAllTable];
        [app iniConfig];
        [self initProfileSetting];
        [DB changeLang:[Util getLang]];
        [app changeUILang];
        [app resizeView];
    } else {
        NSLog(@"NO");
    }
}

-(void) initProfileSetting{
    NSArray *subviews=viewMenu.viewProfile.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[SwitchProfile class]]){
            SwitchProfile *target =(SwitchProfile *) [subviews objectAtIndex:i];
            [target setOn:YES];
        }
    }
}

-(void)iniViewFunSize{
    [self.view setFrame:CGRectMake(0, 0, 51.5, gv.screenH)];
}

-(void)resetViewFunSize{
    [self.view setFrame:CGRectMake(0, 0, 51.5, 71)];
}

-(void) animationSlideMenu{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [viewMenu setFrame:CGRectMake(-262.5+51, 0, viewMenu.frame.size.width, viewMenu.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {

             
         }
     }];
    [UIView animateWithDuration:0.17 delay:0.17 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {

         [btnGear setFrame:CGRectMake(29.5, 27, btnGear.frame.size.width, btnGear.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             
             
         }
     }];
}

-(void) animationSlideOutMenu{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         float offsetX=0;
         if([GV getLoginStatus]==LOGINED){
             offsetX=4;
         }
         [viewMenu setFrame:CGRectMake(-211-51.5-16-offsetX, 0, 262.5, viewMenu.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [self resetViewFunSize];
             [viewMenu clearBorder];
             if([GV getLoginStatus]==LOGINED){
                 [viewMenu addLineBorder];
             }else{
                 [viewMenu addGearBorder];
             }

         }
     }];
    [UIView animateWithDuration:0.17 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [btnGear setFrame:CGRectMake(7.5, 27, btnGear.frame.size.width, btnGear.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             
             
         }
     }];
}

-(void) animationSlideOutToIcon{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [viewMenu setFrame:CGRectMake(-262.5+51.5, 0, 262.5, viewMenu.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [self iniViewFunSize];
             [viewMenu clearBorder];
             if([GV getLoginStatus]==LOGINED){
                 [viewMenu addLineBorder];
             }else{
                 [viewMenu addGearBorder];
             }
             
         }
     }];
}

-(void)animationExpand:(NSString *)name{
    [viewMenu clearBorder];
    [viewMenu addLineBorder];
    NSArray *arrViews=viewMenu.subviews;
    //initial favorite item;
    [self.viewMenu.viewFavorite clearFavoriteItem];
    for(int i=0;i<arrViews.count;i++){
        if([[arrViews objectAtIndex:i] isKindOfClass:ViewExpandedPanel.class]){
            ViewExpandedPanel *scrollViewExpandPanel=(ViewExpandedPanel *)[arrViews objectAtIndex:i];
            if(scrollViewExpandPanel.name==name){
                if([name isEqual:@"favorite"]){
                    ViewFavorite *viewFavorite= (ViewFavorite *) scrollViewExpandPanel;
                    [viewFavorite generateFavoriteItem];
                }
                [scrollViewExpandPanel setHidden:NO];
            }else{
                [scrollViewExpandPanel setHidden:YES];
            }
            
        }
    }

    [UIView animateWithDuration:0.34 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [viewMenu setFrame:CGRectMake(gv.screenW-viewMenu.frame.size.width-58, 0, viewMenu.frame.size.width, viewMenu.frame.size.height)];
        [self.view setFrame:CGRectMake(0, 0, 211+51.5, gv.screenH)];
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];
}

-(void)animationShrinkSuggestionWithKeyboardSize:(CGSize) keyboardSize duraction:(double) duraction curve:(int) curve{
    [UIView animateWithDuration:duraction delay:0.0 options:(curve<<16) animations:^{
        TextComment *txtComment=(TextComment *) viewMenu.viewSuggestion.txtComment;
        ButtonSendSuggestion *btnSend=(ButtonSendSuggestion *) viewMenu.viewSuggestion.btnSend;
        double padding=20;
        if(gv.screenH-keyboardSize.height<btnSend.frame.origin.y+btnSend.frame.size.height){
            [btnSend setFrame:CGRectMake(btnSend.frame.origin.x, gv.screenH- keyboardSize.height-padding-btnSend.frame.size.height, btnSend.frame.size.width, btnSend.frame.size.height)];
            
            [txtComment setFrame:CGRectMake(txtComment.frame.origin.x,txtComment.frame.origin.y,txtComment.frame.size.width,gv.screenH- keyboardSize.height-padding*2-btnSend.frame.size.height-txtComment.frame.origin.y)];

        }
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];
}

-(void)animationExpandSuggestionWithKeyboardSize:(CGSize) keyboardSize duraction:(double) duraction curve:(int) curve{
    [UIView animateWithDuration:duraction delay:0.0 options:(curve<<16) animations:^{
        TextComment *txtComment=(TextComment *) viewMenu.viewSuggestion.txtComment;
        ButtonSendSuggestion *btnSend=(ButtonSendSuggestion *) viewMenu.viewSuggestion.btnSend;
        [txtComment setFrame:txtComment.originFrame];
        [btnSend setFrame:btnSend.originFrame];
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];
}

//handle button click

-(void)loginByFb{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

-(void)loginByGoogle{
    GPPSignIn *_googleSignIn = [GPPSignIn sharedInstance];
    _googleSignIn.shouldFetchGoogleUserEmail=YES;
    // You previously set kClientId in the "Initialize the Google+ client" step
    NSString *kClientId=@"537479459162.apps.googleusercontent.com";
    _googleSignIn.clientID = kClientId;
    _googleSignIn.scopes = [NSArray arrayWithObjects:
                            kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                            kGTLAuthScopePlusMe,
                            nil];
    AppDelegate* appDelegate =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    _googleSignIn.delegate = appDelegate;
    [[GPPSignIn sharedInstance] authenticate];
}

-(void)logout{
    AppDelegate *appDelegate =(AppDelegate*) [[UIApplication sharedApplication]delegate];
    [FBSession.activeSession closeAndClearTokenInformation];
    appDelegate.fbSession=nil;
    [[GPPSignIn sharedInstance] signOut];
    gv.imgProfile=nil;
    [self animationSlideOutToIcon];
    [self changeToUnloginStatus];
    [GV setLoginStatus:LOGOUTED];
}

-(void) sendSuggestion:(NSString *) comment{
    [viewMenu.viewSuggestion changeToSendingStatus];
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&comment=%@&machine_id=%@",gv.urlProtocol,gv.domain,gv.controllerSuggestion,gv.actionAddSuggestion,comment,[Util getUDID]];
    [Util stringAsyncWithUrl:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeout:3 completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [viewMenu.viewSuggestion changeToFinish];
            [viewMenu.viewSecret checkSecretByCondition:@"suggestion"];
        });
    } queue:gv.backgroundThreadManagement];
}

-(void)profileSwitch:(id) sender{
    SwitchProfile *target=(SwitchProfile*) sender;
    if(target.on){
        [DB setSysConfig:target.name value:@"1"];
    }else{
        [DB setSysConfig:target.name value:@"0"];
    }
}

-(void) changeToLoginStatus{
    [viewMenu.viewSecret.gifLoading setHidden:YES];
    //clear scrollViewCollection
    [DB getSecretIconFromRemote:^(NSMutableDictionary *data, NSError *connectionError) {
        [self generateSecretIconByDic:data];
    }];

    [viewMenu changeToLoginView];
    [btnGear changeToLoginView];
}
-(void) changeToUnloginStatus{
    [viewMenu changeToUnloginView:NO];
    [btnGear changeToUnloginView];
}

-(void) generateSecretIconByDic:(NSMutableDictionary *) dic{
    //check local secret icon
    arrSecretIcon= [[NSMutableArray alloc]init];
    NSMutableArray *arrLocalSecretIcon= [[NSMutableArray alloc]init];
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    FMResultSet * result=[db executeQuery:@"SELECT * FROM secret_icon"];
    NSLog(@"generateSecretIconByDic start:len is %d",(int) [[dic objectForKey:@"results"] count]);
    
    while ([result next]) {
        SecretIcon *icon=[[SecretIcon alloc]init];
        icon.name=[result stringForColumn:@"name"];
        icon.icon_id=[result intForColumn:@"icon_id"];
        icon.isGet=[result boolForColumn:@"is_get"];
        icon.isSync=[result boolForColumn:@"is_sync"];
        icon.tip=[result stringForColumn:@"tip"];
        icon.secretId=[result stringForColumn:@"secret_id"];
        [arrLocalSecretIcon addObject:icon];
    }

    //no data from dic in principle
    for(int i=0;i<[[dic objectForKey:@"results"] count];i++){
        BOOL checkLocalExists=NO;
        NSString *secretId=[Util getUDID];
        for(int j=0;j<arrLocalSecretIcon.count;j++){
            if(((SecretIcon *)[arrLocalSecretIcon objectAtIndex:j]).icon_id==[[[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"] intValue]){
                secretId=[result stringForColumn:@"secret_id"];
                checkLocalExists=YES;
                break;
            }
        }
        //local data exist
        //lock a transaction
        @try {
            [db beginTransaction];
            //md5 UDID+created_date

            if(checkLocalExists){
                NSLog(@"%@ already exist",[[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"]);

            }else{
                [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO secret_icon (name,tip,is_get,is_sync,icon_id,secret_id,sort) VALUES ('%@','%@',0,0,'%@','%@',%d)",
                                   [[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"name"],
                                   [[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"tip"],
                                   [[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"],
                                   secretId,
                                   [[[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"sort"] intValue]
                                   ]];
            }

            NSMutableDictionary *jsonInsertSecretIconForMemberResult=[Util jsonWithUrl:[NSString stringWithFormat:@"%@://%@/%@?action=%@&member_id=%@&secret_id=%@&icon_id=%@&creator_ip=%@",
                gv.urlProtocol ,
                gv.domain,
                gv.controllerIcon,
                @"create_secret_icon_for_member",
                gv.localUserId,
                secretId,
                [[[dic objectForKey:@"results"] objectAtIndex:i] valueForKey:@"id"],
                [Util getIPAddress]
            ]];

            if(![[[jsonInsertSecretIconForMemberResult objectForKey:@"results"] valueForKey:@"status"] isEqualToString:@"OK"]){
                NSException *e = [NSException
                                  exceptionWithName:@"Remote Error"
                                  reason:[[jsonInsertSecretIconForMemberResult objectForKey:@"results"] valueForKey:@"msg"]
                                  userInfo:nil];
                @throw e;
            }
            [db commit];
        }
        @catch (NSException *exception) {
            NSLog(@"generateSecretIconByDic error:%@",exception.reason);
            [db rollback];
        }
        @finally {
            
        }
    }
    [result close];
    [db close];
    NSLog(@"gererateSecretIconByDic end");
    //generate view
    [db open];
    result=[db executeQuery:@"SELECT * FROM secret_icon ORDER BY sort"];
    while ([result next]) {
        SecretIcon *icon=[[SecretIcon alloc]init];
        icon.name=[result stringForColumn:@"name"];
        icon.icon_id=[result intForColumn:@"icon_id"];
        icon.isGet=[result boolForColumn:@"is_get"];
        icon.isSync=[result boolForColumn:@"is_sync"];
        icon.tip=[result stringForColumn:@"tip"];
        icon.secretId=[result stringForColumn:@"secret_id"];
        [arrSecretIcon addObject:icon];
    }
    [result close];
    [db close];
    //invoke main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ViewControllerFun.generateSecretIconByDic add subview");
        for(int i=0;i<arrSecretIcon.count;i++){
            ButtonSecretIcon *icon=[[ButtonSecretIcon alloc] initWithSecretIcon:[arrSecretIcon objectAtIndex:i] frame:CGRectMake(i%2*100, floor(i/2)*110+5, 100, 94)];
            [viewMenu.viewSecret.scrollViewSecret addSubview:icon];
        }
        [viewMenu.viewSecret.scrollViewSecret setContentSize:CGSizeMake(viewMenu.viewSecret.scrollViewSecret.frame.size.width, arrSecretIcon.count/2*110+5+94+30)];
        [viewMenu.viewSecret.gifLoading setHidden:YES];
        //change secret icon status by login
        [viewMenu.viewSecret checkSecretByCondition:@"user_login"];

    });
}
@end
