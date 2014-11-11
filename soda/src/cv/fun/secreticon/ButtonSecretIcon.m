//
//  ViewSecretIcon.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/7.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonSecretIcon.h"
#import "Util.h"
#import "DB.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SocialUtil.h"
#import "UserInteractionLog.h"
#import "GameModel.h"

@implementation ButtonSecretIcon
@synthesize iconId,secretId,tip,imgViewIcon,isGet,isSync,lblName,name,iconName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(id)initWithSecretIcon:(SecretIcon *) secretIcon frame:(CGRect) frame{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"new a secret icon:%@",secretIcon.name);
        self.iconId=secretIcon.icon_id;
        self.secretId=secretIcon.secretId;
        self.tip=secretIcon.tip;
        self.name=secretIcon.name;
        self.iconName=[NSString stringWithFormat:@"%@.png",secretIcon.name];
        self.isGet=secretIcon.isGet;
        self.isSync=secretIcon.isSync;
        imgViewIcon =[[AsyncImgView alloc] init];
        [imgViewIcon setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:imgViewIcon ];
        if (self.isGet){
            //check local data
            NSFileManager *NFM=[NSFileManager defaultManager];
            BOOL isDirectory;
            if(![NFM fileExistsAtPath:[self pathOfImage] isDirectory:&isDirectory]){
                NSLog(@"check icon not exist and downlaod");
                [self downloadSecretIcon:NO];
            }else{
                NSLog(@"icon exist and apeend to icon");
                [imgViewIcon setImage:[UIImage imageWithContentsOfFile:[self pathOfImage]]];
            }
        }else{
            [imgViewIcon setImage:[UIImage imageNamed:@"lock.png"]];
        }
    }
    return self;
}

-(void)downloadSecretIcon:(BOOL)isNew{
    self.isLoading=YES;
    [self.loading removeFromSuperview];
    self.loading=nil;
    self.loading=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake((self.frame.size.width-40)/2, (self.frame.size.width-40)/2, 40, 40) thick:2];
    [self addSubview:self.loading];
    [self.loading start];
    NSString *strIsNew=@"0";
    if(isNew){
        strIsNew=@"1";
    }
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadSecretIconFromRemote:) object:strIsNew];
    [self.gv.backgroundThreadManagement addOperation:operation];
}

-(void)downloadSecretIconFromRemote:(NSString *) strIsNew{
    self.isGet=YES;
    //access token
    NSString *accessToken=@"";
    if(self.gv.loginType==Facebook){
        accessToken=[FBSession activeSession].accessTokenData.accessToken;
    }else if(self.gv.loginType==Google){
        accessToken=self.gv.googleAccessToken;
    }
    
    if([strIsNew boolValue] && self.gv.loginType==Facebook){
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [SocialUtil shareNewSecretIconToFacebookWithIconId:self.iconName iconId:self.iconId];
    }
    
    //get icon
    NSString *url= [NSString stringWithFormat:@"%@://%@/%@?action=%@&secret_id=%@&member_id=%@&icon_id=%d&access_token=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerIcon,self.gv.actionDownloadSecretIcon,self.secretId,self.gv.localUserId,self.iconId,accessToken];
    [Util saveImgFile:url pathDest:[self pathOfImage] isOverWrite:NO];

    
    url=[url stringByAppendingFormat:@"&is_over=%@",@"true"];
    NSLog(@"%@",url);
    [Util saveImgFile:url pathDest:[self pathOfOverImage] isOverWrite:NO];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(updateLocalDBAndAppendRemoteLog:) object:strIsNew];
    [self.gv.FMDatabaseQueue addOperation:operation];
}

-(void)changeLockIconToDownloadIcon{
    NSLog(@"changeLockIconToDownloadIcon:%@",self.name);
    [imgViewIcon setImage:[UIImage imageWithContentsOfFile:[self pathOfImage]]];
}


//FMDatabaseQueue;
-(void)updateLocalDBAndAppendRemoteLog:(NSString *) strIsNew{
        NSLog(@"downloadSecretIcon async:%@",self.name);
        BOOL isNew=[strIsNew boolValue];
        FMDatabase *db=[DB getShareInstance].db;
        [db open];
        [db beginTransaction];
        @try {
            //update local db
            [db executeUpdate:[NSString stringWithFormat:@"UPDATE secret_icon SET is_get=1 WHERE name='%@'",self.name]];

            //access token
            NSString *accessToken=@"";
            if(self.gv.loginType==Facebook){
                accessToken=[FBSession activeSession].accessTokenData.accessToken;
            }else if(self.gv.loginType==Google){
                accessToken=self.gv.googleAccessToken;
            }
            //add log to remote;
            NSString *addDownloadLogURL=[NSString stringWithFormat:@"%@://%@/%@?action=%@&member_id=%@&icon_id=%d&creator_ip=%@&access_token=%@",
                                         self.gv.urlProtocol ,
                                         self.gv.domain,
                                         self.gv.controllerIcon,
                                         self.gv.actionAddDownloadSecretIconLog,
                                         self.gv.localUserId,
                                         self.iconId,
                                         [Util getIPAddress],
                                         accessToken
                                         ];
            NSMutableDictionary *jsonInsertSecretIconForMemberResult=[Util jsonWithUrl:addDownloadLogURL];
            if(![[jsonInsertSecretIconForMemberResult valueForKey:@"status"] isEqualToString:@"OK"]){
                NSException *e = [NSException
                                  exceptionWithName:@"Remote Error"
                                  reason:[[jsonInsertSecretIconForMemberResult objectForKey:@"results"] valueForKey:@"msg"]
                                  userInfo:nil];
                @throw e;
            }
            [db commit];
        }
        @catch (NSException *exception) {
            [db rollback];
            self.isGet=NO;
        }
        @finally {
            [db close];
            NSLog(@"downloadSecretIcon finish:%@",self.name);
            [self performSelectorOnMainThread:@selector(changeLockIconToDownloadIcon) withObject:nil waitUntilDone:NO];
            self.isLoading=NO;
            if(isNew){
                GameNotification *notification=[[GameNotification alloc]init];
                notification.icon=[UIImage imageWithContentsOfFile:[self pathOfImage]];
                notification.title=[NSString stringWithFormat:@"%@: %@",[DB getUIInnerFMDatabaseQueue:@"new_secret_icon" ],[DB getUIInnerFMDatabaseQueue:self.name]];
                NSString *storyURL=@"";
                notification.msg=@"";
                [GameModel addGameNotification:notification];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.loading stop];
            });
        }
}




-(void)loadImgCom{
    NSLog(@"ViewSecretIcon.loadImgCom");
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==MENU){
        [self toTouchStatus];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toCommonStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.timerCheckShowHint invalidate];
    self.timerCheckShowHint=nil;
    if(self.isCanceled){
        return;
    }
    [self toCommonStatus];
    [super touchesCancelled:touches withEvent:event];
}

-(void)toTouchStatus{
    UIImage *imgIcon=nil;
    if(self.isLoading){
        return;
    }
    self.timerCheckShowHint=[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(showHint:) userInfo:nil repeats:NO];

    if(isGet){
        imgIcon=[UIImage imageWithContentsOfFile:[self pathOfOverImage]];
    }else{
        imgIcon=[UIImage imageNamed:@"lock_over.png"];
    }
    [imgViewIcon setImage:imgIcon];
}

-(void)showHint:(id)sender{
    if(isGet){
        [UserInteractionLog showTip:self titleKey:[DB getUI:self.name] tipKey:tip];
    }else{
        [UserInteractionLog showTip:self titleKey:@"operation_hint" tipKey:tip];
    }
    //這邊比較特別 因為時間差的關係 事件傳到root 不會被設定為 tip_shown
    self.gv.previousStatusForTip=MENU;
    [GV setGlobalStatus:TIP_SHOWED];
}

-(void)toCommonStatus{
    UIImage *imgIcon=nil;
    if(isGet){
        imgIcon=[UIImage imageWithContentsOfFile:[self pathOfImage]];
    }else{
        imgIcon=[UIImage imageNamed:@"lock.png"];

    }
    [imgViewIcon setImage:imgIcon];
}

-(NSString *)pathOfImage{
    return [NSString stringWithFormat:@"%@/%@",self.gv.pathIcon,iconName];
}
-(NSString *)pathOfOverImage{
    NSMutableString *pImgOverPath=[NSMutableString stringWithString:[self pathOfImage]];
    [pImgOverPath insertString:@"_over" atIndex:[pImgOverPath rangeOfString:@"." options:NSBackwardsSearch].location];
    return pImgOverPath;
}
@end
