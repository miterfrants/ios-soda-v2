//
//  LoadingIcon.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LoadingIcon.h"
#import "GV.h"
@implementation LoadingIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *icon=[UIImage imageNamed:@"logo.png"];
        self.imgViewIcon=[[UIImageView alloc] init];
        [self.imgViewIcon setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.imgViewIcon setImage:icon];
        [self addSubview:self.imgViewIcon];
        
        self.lblLoadingInfo=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height+8, frame.size.width, 28)];
        [self.lblLoadingInfo setTextColor:[UIColor whiteColor]];
        [self.lblLoadingInfo setFont:[GV sharedInstance].fontSettingTitle];
        [self.lblLoadingInfo setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lblLoadingInfo];
        
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
        self.isHiding=NO;
        self.isStop=NO;
    }
    return self;
}

-(void)start{
    self.lblLoadingInfo.text=@"";
    [self.animationTimer invalidate];
    self.animationTimer =nil;
    self.animationTimer=[NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(_start) userInfo:nil repeats:YES];
}
-(void)stop{
    [self hide];
}
-(void)_start{
    self.imgViewIcon.transform=CGAffineTransformMakeRotation([[self.imgViewIcon.layer valueForKeyPath:@"transform.rotation.z"] floatValue]+M_PI/3);
}



-(void)hide{
    self.isHiding=YES;
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setAlpha:0.0];
     } completion:^(BOOL finished) {
         if (finished){
             [self.animationTimer invalidate];
             self.animationTimer=nil;
             [self setHidden:YES];
         }
     }];
   
}


@end
