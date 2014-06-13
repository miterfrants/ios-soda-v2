//
//  ButtonForPersonal.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonForPersonal.h"
#import "DB.h"
#import "ViewTip.h"

@implementation ButtonForPersonal
@synthesize isDisable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame name:(NSString *) pName
{
    self = [super initWithFrame:frame name:pName];
    if (self) {
        [self changeToUnlogin];
    }
    return self;
}


-(void) changeToUnlogin{
    isDisable=YES;
    UIImage *bg=[UIImage imageNamed:[NSString stringWithFormat:@"%@_disable.png",self.name]];
    [self.imgViewIcon setImage:bg];
}

-(void) changeToLogin{
    isDisable=NO;
    UIImage *bg=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",self.name]];
    [self.imgViewIcon setImage:bg];
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==MENU){
        UIImage *icon=[UIImage imageNamed:[NSString stringWithFormat:@"%@_over.png", self.name]];
        [self.imgViewIcon setImage:icon];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isDisable && [GV getGlobalStatus]!=TIP && [GV getGlobalStatus]!=TIP_SHOWED){
        ViewTip *tip=(ViewTip *)self.gv.viewTip;
        [tip statusPreviousStatusToTip:self title:[DB getUI:@"operating_tip"] msg:[DB getUI:@"please_login"]];
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}


-(void)toUnHighLightStatus{
    NSString *fileName=@"";
    if(isDisable){
        fileName=[NSString stringWithFormat:@"%@_disable.png",self.name];
    }else{
        fileName=[NSString stringWithFormat:@"%@.png",self.name];
    }
    UIImage *bg=[UIImage imageNamed:fileName];
    [self.imgViewIcon setImage:bg];
}

@end
