//
//  AppDelegate.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/2.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
//1:轉換語言和rest 沒有套用 ui 轉換語言現在都是英文
//2:轉換語言的時候  root.scrollViewControllerCate.viewIconEditPeanel.viewEditKeyword 寬度沒有調整
//3:有時候進入列表展開沒有把下面的列表推開 在沒有 sorting key的時候
//4:沒有sorting key 的狀況在還沒讀完資料的時候 展開列表會重疊到

#import "AppDelegate.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GoogleMaps/GoogleMaps.h>
#import "DB.h"
#import "GV.h"
#import "File.h"
#import "Util.h"

@implementation AppDelegate
@synthesize root,gv,tip;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    //fb login
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {

        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info,publish_actions"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
    //initial config
    NSLog(@"initial config start");
    [self iniConfig];
    
    //map key;
    [GMSServices provideAPIKey:@"AIzaSyCW4c3kjZgQeAL7QGF0tWKJ9OycP19slW4"];
    
    
    //temp;

    
    //root view
    NSLog(@"initial root view");
    root=[[ViewControllerRoot alloc]init];
    [self.window addSubview:[root view]];
    NSLog(@"root view append");
    
    
    //tip view
    NSLog(@"initial tip view");
    tip=[[ViewTip alloc]init];
    [self.window addSubview:tip];
    gv.viewTip=tip;
    NSLog(@"tip view append");
    
    //keyboardtop input
    self.keyboardTopInput=[[KeyboardTopInput alloc] initWithFrame:CGRectMake(0, self.gv.screenH, self.gv.screenW, 35)];
    [self.window addSubview:self.keyboardTopInput];
    self.gv.keyboardTopInput=self.keyboardTopInput;
    return YES;
}

-(void)iniConfig{
    gv=[GV sharedInstance];
    
    //ini url
    gv.domain=@"36.224.19.242";
    gv.controllerCollection=@"api/soda/collection.aspx";
    gv.controllerUI=@"api/soda/ui.aspx";
    gv.controllerIcon=@"api/soda/icon.aspx";
    gv.controllerSuggestion=@"api/soda/suggestion.aspx";
    gv.controllerOfficialSuggestPlace=@"api/soda/official_suggestion_place.aspx";
    gv.controllerReview=@"api/soda/review.aspx";
    gv.controllerPlace=@"api/soda/place.aspx";
    
    gv.actionGetDefaultCollection=@"default";
    gv.actionGetDefaultIcon=@"default";
    gv.actionDownloadSecretIcon=@"download_secret_icon";
    gv.actionAddSuggestion=@"add";
    gv.actionAddOfficialSuggestPlace=@"add";
    gv.actionCheckExistsOfficialSuggestPlace=@"exist";
    gv.actionDelOfficialSuggestPlace=@"del";
    gv.actionAddReview=@"add";
    gv.actionGetReview=@"get";
    gv.actionGetReviewSelf=@"get-for-self";
    gv.actionSearchPlace=@"search";
    gv.actionAddPlace=@"add";
    gv.urlProtocol=@"http";
    gv.urlIcon=[NSString stringWithFormat:@"%@://%@/img/soda",gv.urlProtocol,gv.domain];
    
    //ini path
    NSLog(@"ini path");
    gv.pathRoot = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    gv.pathIcon=[NSString stringWithFormat:@"%@/%@",gv.pathRoot,@"icon"];
    gv.pathDB=[NSString stringWithFormat:@"%@/%@",gv.pathRoot,@"db"];
    gv.pathImg=[NSString stringWithFormat:@"%@/%@",gv.pathRoot,@"img"];

    //ini directory
    NSLog(@"ini directory");
    [File iniDirectory];

    //ini db
    NSLog(@"ini db");
    gv.tabCollection=@"collection";
    [DB iniSysConfig];

    //download icon
    NSLog(@"download default icon");
    [File downloadDefaultIcon];
    
    //initial lang
    NSLog(@"initial lang");
    gv.dicLang=[[NSMutableDictionary alloc]init];
    [gv.dicLang setValue:@"繁體中文" forKey:@"zh_tw"];
    [gv.dicLang setValue:@"简体中文" forKey:@"zh_cn"];
    [gv.dicLang setValue:@"日本語" forKey:@"ja"];
    [gv.dicLang setValue:@"English" forKey:@"en_us"];

    
    //common
    NSLog(@"initial common variable");
    gv.screenH=[UIScreen mainScreen].bounds.size.height;
    gv.screenW=[UIScreen mainScreen].bounds.size.width;
    gv.lang=[Util getLang];
    gv.listBufferCount=20;
    gv.isBlurModel=NO;
    
    //很容易 OVER_REQUEST_LIMIT You have exceeded your daily request quota for this API
    //目前想到一個方法用地點密度的方式在radar search 的時候做local server 地點密度的測試
    //如果密度夠高就用local端的資料
    //在展開list的時候同時把資料送回去給server
    gv.gpApiPool=[[GooglePlaceAPIPool alloc] initWithKey:[[NSMutableArray alloc] initWithObjects:
                                                          @"AIzaSyDX0drEfiBpop1Fn7h1BKUPFI42LuYPcRg",
//                                                          @"AIzaSyDX0drEfiBpop1Fn7h1BKUPFI42LuYPcRg",
//                                                          @"AIzaSyA-nivqsEJbg4ecIS7QjMotzLF4D6Sq5rQ",
//                                                          @"AIzaSyDDe4eiJ73e-_gMpYwfFv8gm66Ik6QBCIQ",
//                                                          @"AIzaSyB9g18XY0iTDvYm0xtbql5vaXa6HQom8HU",
//                                                          @"AIzaSyAWEcWQOrop14MHNVW60nSYesNMcWAnlZY",
//                                                          @"AIzaSyCRgPD8_6S-NN2f0_nsRCm1HattcSWb4is",
//                                                          @"AIzaSyADcSB257VJ__P4ZRTMRqy9krkNMViTbDQ",
//                                                          @"AIzaSyAJdt_PQm-GUqn7MBbXBcnH6Kr3ClL0zic",
                                                          nil]] ;

    
    //font
    gv.titleFont=[UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    gv.contentFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    gv.tipTitleFont=[UIFont fontWithName:@"HelveticaNeue" size:20.0f];
    gv.fontScrollTitle=[UIFont fontWithName:@"HelveticaNeue-Medium" size:24.0f];
    gv.tipMsgFont=[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    gv.fontSettingTitle=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    gv.fontSettingPicker=[UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    gv.fontMenuTitle=[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    gv.fontCountOfReview=[UIFont fontWithName:@"HelveticaNeue" size:10.0f];
    gv.fontListFunctionTitle=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    gv.fontListFunctionFilter=[UIFont fontWithName:@"HelveticaNeue" size:16.0f];
    gv.fontListFunctionSorting=[UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f];
    gv.fontListName=[UIFont fontWithName:@"HelveticaNeue" size:18.0f];
    gv.fontListAnnounceDate=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    gv.fontButtonText=[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    gv.fontInfoWindowTitle=[UIFont fontWithName:@"HelveticaNeue" size:17.4f];
    gv.fontInfoWindowDistance=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    gv.fontInfoWindowAddress=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    gv.fontFuncFavoriteName=[UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    gv.fontFuncFavoriteAddress=[UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    //key
    gv.googleWebKey=@"AIzaSyCYM1UUnXbgP3eD__x2EjIugNOy-vE3McY";
    
    //get aysnc background thread
    gv.backgroundThreadManagement=[[NSOperationQueue alloc] init];
    gv.FMDatabaseQueue =[[NSOperationQueue alloc]init];
    [gv.FMDatabaseQueue setMaxConcurrentOperationCount:1];
    gv.GooglePlaceDetailQueue =[[NSOperationQueue alloc]init];
    [gv.GooglePlaceDetailQueue setMaxConcurrentOperationCount:1];
    NSLog(@"finish initail conifg");
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as the handler passed to any open calls.
    NSString *strURL =[ NSString stringWithFormat:@"%@",url];
    if([strURL hasPrefix:@"fb"]){
        [FBSession.activeSession setStateChangeHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
             
             NSLog(@"facebook accessToken:%@",session.accessTokenData.accessToken);
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }else{
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];

    }

}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
         NSLog(@"facebook accessToken:%@",session.accessTokenData.accessToken);
        // Show the user the logged-in UI
        if(gv==nil){
            self.gv=[GV sharedInstance];
        }
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

-(void)userLoggedIn{
    //prepare data
    NSLog(@"userLoggedIn");
    gv.loginType=Facebook;
    [self initialUserInfoByFB];
    [GV setLoginStatus:LOGINED];
}

-(void)userLoggedOut{
    NSLog(@"userLoggedOut");
    [self resetUserInfo];
    [GV setLoginStatus:LOGOUTED];
    [root.viewControllerFun changeToUnloginStatus];
}

-(void)initialUserInfoByFB{
    [[FBRequest requestForMe] startWithCompletionHandler:
        ^(FBRequestConnection *connection,
        NSDictionary<FBGraphUser> *user,
        NSError *error) {
            if (!error) {
                NSMutableDictionary *dicUserInfo= [Util jsonWithUrl:[NSString stringWithFormat:@"http://%@/controller/mobile/member.aspx?action=get_local_user&source=1&outer_id=%@",gv.domain,user.id]] ;
                gv.localUserId=[[[dicUserInfo objectForKey:@"results"] valueForKey:@"user_id"] stringValue];

                gv.localUserName=[[dicUserInfo objectForKey:@"results"] valueForKey:@"user_name"];
                 NSURL *imgURL=[NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100" ,user.id]];
                 NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                 gv.imgProfile=[UIImage imageWithData:imgData];
                root.viewControllerFun.viewMenu.viewProfile.lblShareFavoriteToSocial.text= [DB getUI:@"share_favorite_on_facebook"];
                root.viewControllerFun.viewMenu.viewProfile.lblShareGoodToSocial.text= [DB getUI:@"share_good_on_facebook"];
                root.viewControllerFun.viewMenu.viewProfile.lblShareIconToSocial.text= [DB getUI:@"share_icon_on_facebook"];
                [root.viewControllerFun changeToLoginStatus];
             }else{
                 NSLog(@"%@",error);
             }
         }];
}

//google plus auth
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if(auth.canAuthorize){
        GTLServicePlus *service = [[GTLServicePlus alloc] init];
        service.retryEnabled = YES;
        service.authorizer = auth;
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        query.completionBlock = ^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (error == nil) {
            } else {
                NSLog(@"error:%@", error);
            }
        };
        [service executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    gv.loginType=Google;
                    NSMutableDictionary *dicUserInfo= [Util jsonWithUrl:[NSString stringWithFormat:@"http://%@/controller/mobile/member.aspx?action=get_local_user&source=2&outer_id=%@",self.gv.domain,person.identifier]] ;
                    NSLog(@"%@",[NSString stringWithFormat:@"http://%@/controller/mobile/member.aspx?action=get_local_user&source=2&outer_id=%@",self.gv.domain,person.identifier]);
                    gv.localUserId=[[[dicUserInfo objectForKey:@"results"] valueForKey:@"user_id"] stringValue];
                    
                    gv.localUserName=[[dicUserInfo objectForKey:@"results"] valueForKey:@"user_name"];
                    
                    NSURL *imgURL=[NSURL URLWithString: person.image.url];
                    NSData *imgData=[NSData dataWithContentsOfURL:imgURL];
                    gv.imgProfile=[UIImage imageWithData:imgData];
                    [root.viewControllerFun changeToLoginStatus];
                    [GV setLoginStatus:LOGINED];
                    root.viewControllerFun.viewMenu.viewProfile.lblShareFavoriteToSocial.text= [DB getUI:@"share_favorite_on_google"];
                    root.viewControllerFun.viewMenu.viewProfile.lblShareGoodToSocial.text= [DB getUI:@"share_good_on_google"];
                    root.viewControllerFun.viewMenu.viewProfile.lblShareIconToSocial.text= [DB getUI:@"share_icon_on_google"];
                    /*NSString *description = [NSString stringWithFormat:
                     @"%@\n%@", person.displayName,
                     person.aboutMe];*/
                }
            }];
        
        
    }else{
        NSLog(@"Google not auth");
    }
}


-(void)resetUserInfo{
    gv.imgProfile=nil;
    gv.localUserId=@"";
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)changeUILang{
    root.viewControllerTop.lblHint.text=[DB getUI:@"search"];
    
    ScrollViewCate *scrollViewCate=(ScrollViewCate *)root.scrollViewControllerCate.scrollViewCate;
    int childLen=(int)scrollViewCate.subviews.count;
    NSArray *subViews=scrollViewCate.subviews;
    for(int i=0;i<childLen;i++){
        if([[subViews objectAtIndex:i] isKindOfClass:[ButtonCate class]]){
            ButtonCate *btn=(ButtonCate *)[subViews objectAtIndex:i];
            [btn removeFromSuperview];
        }
    }
    NSString *lang=[DB getSysConfig:@"lang"];
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    FMResultSet *results=[db executeQuery:[NSString stringWithFormat:@"SELECT * FROM collection WHERE lang='%@' ORDER BY sort",lang]];
    int i=0;
    while([results next]){
        NSString *title=[results stringForColumn:@"title"];
        NSString *name=[results stringForColumn:@"name"];
        NSString *keyword=[results stringForColumn:@"keyword"];
        NSString *icon=[results stringForColumn:@"icon"];
        int iden=[results intForColumn:@"id"];
        ButtonCate *buttonCate= [[ButtonCate alloc] initWithIconName:icon frame:CGRectMake(i%2*116+52, floor(i/2)*132, 100, 94) title:title name:name lang:lang keyword:keyword iden:iden];
        [scrollViewCate addSubview:buttonCate];
        i+=1;
    }
    [results close];
    [db close];

    root.scrollViewControllerCate.viewIconEditPeanel.viewEditKeyword.lblDisplayTitle.text=[DB getUI:@"edit_keyword"];
    root.scrollViewControllerCate.viewIconEditPeanel.viewEditTitle.lblDisplayTitle.text=[DB getUI:@"edit_title"];
    root.viewControllerFun.viewMenu.viewConfig.lblTitle.text=[DB getUI:@"config"];
    root.viewControllerFun.viewMenu.viewSuggestion.lblTitle.text=[DB getUI:@"suggestion"];
    root.viewControllerFun.viewMenu.viewProfile.lblTitle.text=[DB getUI:@"profile"];
    root.viewControllerFun.viewMenu.viewProfile.lblShareFavoriteToSocial.text=[DB getUI:@"share_favorite_on_facebook"];
    root.viewControllerFun.viewMenu.viewProfile.lblShareGoodToSocial.text=[DB getUI:@"share_good_on_facebook"];
    root.viewControllerFun.viewMenu.viewProfile.lblShareIconToSocial.text=[DB getUI:@"share_icon_on_facebook"];
    root.viewControllerFun.viewMenu.viewProfile.lblOperatingTip.text=[DB getUI:@"operating_tip"];
    root.viewControllerFun.viewMenu.viewProfile.lblNotificationForDiscover.text=[DB getUI:@"notification_for_discover"];
    root.viewControllerFun.viewMenu.viewProfile.btnLogout.lblTitle.text=[DB getUI:@"logout"];
    
    root.viewControllerFun.viewMenu.viewConfig.btnRest.lblTitle.text=[DB getUI:@"reset"];
    root.viewControllerFun.viewMenu.viewConfig.lblLang.text=[DB getUI:@"lang"];
    
    root.viewControllerFun.viewMenu.viewSuggestion.btnSend.lblTitle.text=[DB getUI:@"send"];
    root.viewControllerFun.viewMenu.viewFavorite.lblTitle.text=[DB getUI:@"favorite"];
    root.viewControllerFun.viewMenu.viewSecret.lblTitle.text=[DB getUI:@"icon_collection"];
    root.viewControllerFun.viewMenu.viewGoodsBox.lblTitle.text=[DB getUI:@"goods_box"];
    
}

-(void) resizeView{
    [root.scrollViewControllerCate.scrollViewCate setContentSize:CGSizeMake(gv.screenW,(root.scrollViewControllerCate.scrollViewCate.subviews.count-3)/2*132+50+94)];
    root.scrollViewControllerCate.scrollViewCate.originalHeight =(root.scrollViewControllerCate.scrollViewCate.subviews.count-3)/2*132+50+94;
    NSLog(@"iniview:%d",(int)root.scrollViewControllerCate.scrollViewCate.subviews.count);
}

@end
