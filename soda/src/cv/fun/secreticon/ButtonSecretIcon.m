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
                [self downloadSecretIcon];
            }else{
                //NSLog(@"icon exist and apeend to icon");
                [imgViewIcon setImage:[UIImage imageWithContentsOfFile:[self pathOfImage]]];
            }
        }else{
            [imgViewIcon setImage:[UIImage imageNamed:@"lock.png"]];
        }
    }
    return self;
}

-(void)downloadSecretIcon{
    //這邊會有lock 問題 要抓單一執行續來處理
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_downloadSecretIcon) object:nil];
    [self.gv.FMDatabaseQueue addOperation:operation];

}

-(void)changeLockIconToDownloadIcon{
    NSLog(@"changeLockIconToDownloadIcon:%@",self.name);
    [imgViewIcon setImage:[UIImage imageWithContentsOfFile:[self pathOfImage]]];
}

-(void)_downloadSecretIcon{
        NSLog(@"downloadSecretIcon async:%@",self.name);
        FMDatabase *db=[DB getShareInstance].db;
        [db open];
        [db beginTransaction];
        @try {
            self.isGet=YES;
            //get icon
            NSString *url= [NSString stringWithFormat:@"%@://%@/%@?action=%@&secret_id=%@&member_id=%@&icon_id=%d",self.gv.urlProtocol,self.gv.domain,self.gv.controllerIcon,self.gv.actionDownloadSecretIcon,self.secretId,self.gv.localUserId,self.iconId];
            [Util saveImgFile:url pathDest:[self pathOfImage] isOverWrite:NO];

            url=[url stringByAppendingFormat:@"&is_over=%@",@"true"];

            [Util saveImgFile:url pathDest:[self pathOfOverImage] isOverWrite:NO];
            //update local db
            [db executeUpdate:[NSString stringWithFormat:@"UPDATE secret_icon SET is_get=1 WHERE name='%@'",self.name]];
            
            //update remote db and get new secret key
            
            
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
    if(self.isCanceled){
        return;
    }
    [self toCommonStatus];
    [super touchesCancelled:touches withEvent:event];
}

-(void)toTouchStatus{
    UIImage *imgIcon=nil;
    if(isGet){
        imgIcon=[UIImage imageWithContentsOfFile:[self pathOfOverImage]];
    }else{
        imgIcon=[UIImage imageNamed:@"lock_over.png"];
    }
    [imgViewIcon setImage:imgIcon];
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
