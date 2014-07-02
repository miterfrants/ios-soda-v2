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
        
        
        //profile switch change
        [viewMenu.viewConfig.switchNotificationForDiscover addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewConfig.switchOperatingTip addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewConfig.switchShareFavoriteToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewConfig.switchShareGoodToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
        [viewMenu.viewConfig.switchShareIconToSocial addTarget:self action:@selector(profileSwitch:) forControlEvents:UIControlEventValueChanged];
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
    }else if([GV getGlobalStatus]==LIST || [GV getGlobalStatus]==LIST_EXPAND ){
        [self.view.superview bringSubviewToFront:self.view];
        [self statusCurrentToMenu];
    }else if([touch.view isKindOfClass:[ButtonLogout class]]){
        [self logout];
    }else if([touch.view isKindOfClass:[ButtonMail class]]){
        [self sendMail];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)sendMail{
    self.mail = [[MFMailComposeViewController alloc]init];
    self.mail.mailComposeDelegate = self;
    [self.mail setToRecipients:[NSArray arrayWithObjects:@"miterfrants@gmail.com",nil]];
    [self.mail setCcRecipients:[NSArray arrayWithObjects:@"miterfrants@hotmail.com",@"dream.devil@msa.hinet.net",nil]];
    [self.mail setSubject:[DB getUI:@"offer_soda_some_suggestion"]];
    [self.mail setMessageBody:[DB getUI:@""] isHTML:NO];
    [self presentViewController:self.mail animated:YES completion:^{
    }];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result) {
        [viewMenu.viewSecret checkSecretByCondition:@"suggestion"];
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.view setFrame:CGRectMake(0, 0, 211+51.5, self.gv.screenH)];
    }];
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
    [self.viewMenu.viewProfile timerStop];
    [self resetViewFunSize];
    [self animationSlideOutMenu];
    [GV setGlobalStatus:[GV sharedInstance].previousStatusForMenu];
}


- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
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
         [btnGear setFrame:CGRectMake(29.5, btnGear.frame.origin.y, btnGear.frame.size.width, btnGear.frame.size.height)];
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
                }else if([name isEqual:@"profile"]){
                    ViewProfile *viewProfile= (ViewProfile *) scrollViewExpandPanel;
                    [viewProfile initProfile];
                }else if([name isEqual:@"suggestion"]){
                    ViewSuggestion *viewSuggestion= (ViewSuggestion *) scrollViewExpandPanel;
                    [viewSuggestion getAboutUs];
                }
                [scrollViewExpandPanel setHidden:NO];
            }else{
                [scrollViewExpandPanel setHidden:YES];
            }
            
        }
    }

    [UIView animateWithDuration:0.34 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        [viewMenu setFrame:CGRectMake(gv.screenW-viewMenu.frame.size.width-58, 0, viewMenu.frame.size.width, viewMenu.frame.size.height)];
        [btnGear setFrame:CGRectMake(12, self.btnGear.frame.origin.y, self.btnGear.frame.size.width, self.btnGear.frame.size.height)];
        [self.view setFrame:CGRectMake(0, 0, 211+51.5, gv.screenH)];
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
        //check local secret icon is expired;
        //and build self.arrSecretIcon;
        [self renewExpiredSecretIconOnLocalDB:data];
        //use self.arrSecretIcon to generate secret icon view;
        [self generateSecretIconByDic];
    }];

    [viewMenu changeToLoginView];
    [btnGear changeToLoginView];
}



-(void) changeToUnloginStatus{
    [viewMenu changeToUnloginView:NO];
    [btnGear changeToUnloginView];
}

-(void)renewExpiredSecretIconOnLocalDB:(NSMutableDictionary *)dicSecretItemFromRemote{
    NSLog(@"%@",@"renewExpiredSecretIconOnLocalDB");
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_renewExpiredSecretIconOnLocalDB:) object:dicSecretItemFromRemote];
    [self.gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
}

-(void)_renewExpiredSecretIconOnLocalDB:(NSMutableDictionary *)dicSecretItemFromRemote{
    NSLog(@"_renewExpiredSecretIconOnLocalDB");
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    FMResultSet *result=[db executeQuery:@"SELECT * FROM secret_icon"];
    NSMutableArray *arrSecretFromLocal=[[NSMutableArray alloc]init];
    //檢查本機端資料是否過期 過期把舊資料更新 檔案刪除
    while([result next]){
        SecretIcon *secretIcon=[[SecretIcon alloc] init];
        secretIcon.name=[result stringForColumn:@"name"];
        secretIcon.icon_id=[[result stringForColumn:@"icon_id"] intValue];
        secretIcon.tip=[result stringForColumn:@"tip"];
        secretIcon.updatedTime=[result stringForColumn:@"created_time"];
        secretIcon.sort=[[result stringForColumn:@"sort"] intValue];
        secretIcon.isGet=[result boolForColumn:@"is_get"];
        [arrSecretFromLocal addObject:secretIcon];
    }
    NSMutableArray *arrSecretFromRemote=[[dicSecretItemFromRemote objectForKey:@"results"] mutableCopy];
    for(int i=0;i<arrSecretFromRemote.count;i++){
        BOOL isOnlyExistsOnRemote=YES;
        for(int j=0;j<arrSecretFromLocal.count;j++){
            SecretIcon *secretIcon=(SecretIcon *)[arrSecretFromLocal objectAtIndex:j];
            if([[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"id"] intValue] ==secretIcon.icon_id){
                [db executeUpdate:[NSString stringWithFormat:@"UPDATE secret_icon SET is_get=%d,tip='%@',sort=%d,name='%@',created_time='%@' WHERE icon_id=%d",
                                   [[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"is_get"] intValue],
                                    [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"tip"],
                                   [[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"sort"] intValue],
                                   [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"name"],
                                   [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"updated_time"],
                                   [[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"id"] intValue]
                                   ]];
                secretIcon.tip=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"tip"];
                secretIcon.sort=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"sort"] intValue];
                secretIcon.name=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"name"];
                secretIcon.updatedTime=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"updated_time"];
                secretIcon.icon_id=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"id"] intValue];
                secretIcon.isGet=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"is_get"] boolValue];
                isOnlyExistsOnRemote=NO;
                continue;
            }
        }
        //沒有local 端的資料 但remote 有資料
        if(isOnlyExistsOnRemote){
            [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO secret_icon (name,tip,is_get,icon_id,sort,created_time) VALUES ('%@','%@',%d,'%@',%d,'%@')",
                               [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"name"],
                               [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"tip"],
                               [[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"is_get"] intValue],
                               [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"id"],
                               [[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"sort"] intValue],
                               [[arrSecretFromRemote objectAtIndex:i] valueForKey:@"updated_time"]
                               ]];
            SecretIcon *secretIcon=[[SecretIcon alloc]init];
            secretIcon.name=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"name"];
            secretIcon.icon_id=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"id"] intValue];
            secretIcon.tip=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"tip"];
            secretIcon.updatedTime=[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"updated_time"];
            secretIcon.sort=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"sort"] intValue];
            secretIcon.isGet=[[[arrSecretFromRemote objectAtIndex:i] valueForKey:@"is_get"] boolValue];
            [arrSecretFromLocal addObject:secretIcon];
        }
    }
    self.arrSecretIcon =[arrSecretFromLocal mutableCopy];
    [result close];
    [db close];
}

-(void) generateSecretIconByDic{
    NSSortDescriptor *sort=nil;
    sort=[NSSortDescriptor sortDescriptorWithKey:@"sort" ascending:YES];
    [self.arrSecretIcon sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"ViewControllerFun.generateSecretIconByDic add subview");
        for(int i=0;i<self.arrSecretIcon.count;i++){
            ButtonSecretIcon *icon=[[ButtonSecretIcon alloc] initWithSecretIcon:[self.arrSecretIcon objectAtIndex:i] frame:CGRectMake(i%2*100, floor(i/2)*110+5, 100, 94)];
            [viewMenu.viewSecret.scrollViewSecret addSubview:icon];
        }
        [viewMenu.viewSecret.scrollViewSecret setContentSize:CGSizeMake(viewMenu.viewSecret.scrollViewSecret.frame.size.width, arrSecretIcon.count/2*110+5+94+30)];
        [viewMenu.viewSecret.gifLoading setHidden:YES];
        //change secret icon status by login
        [viewMenu.viewSecret checkSecretByCondition:@"user_login"];
    });
}
@end
