//
//  LoadingCircle.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LoadingCircle.h"

@implementation LoadingCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        CAShapeLayer *bgLayer=[CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        double thida=120;
        double width=3;
        double outerR=self.frame.size.width/2;
        double innerR=self.frame.size.width/2-width;
        [bgPath moveToPoint:CGPointMake(frame.size.width/2+innerR*cos(thida*M_PI/180), frame.size.width/2+innerR*sin(thida*M_PI/180))];
        [bgPath addArcWithCenter:CGPointMake(frame.size.width/2, frame.size.width/2) radius:frame.size.width/2-3 startAngle:thida*M_PI/180 endAngle:0 clockwise:YES];
        [bgPath addLineToPoint:CGPointMake(frame.size.width, frame.size.width/2)];
        [bgPath addArcWithCenter:CGPointMake(frame.size.width/2, frame.size.width/2) radius:outerR startAngle:0 endAngle:thida*M_PI/180 clockwise:NO];
        bgLayer.fillColor=[UIColor whiteColor].CGColor;
        bgLayer.path=bgPath.CGPath;
        [self.layer addSublayer:bgLayer];
    }
    return self;
}


-(void)start{
    [self.animationTimer invalidate];
    self.animationTimer =nil;
    self.animationTimer=[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(_start) userInfo:nil repeats:YES];
}
-(void)stop{
    [self hide];
}
-(void)_start{
    self.transform=CGAffineTransformMakeRotation([[self.layer valueForKeyPath:@"transform.rotation.z"] floatValue]+M_PI/30);
}



-(void)hide{
    self.isHiding=YES;
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setAlpha:0.0];
     } completion:^(BOOL finished) {
         if (finished){
            self.transform=CGAffineTransformMakeRotation(0);
             [self.animationTimer invalidate];
             self.animationTimer=nil;
             [self setHidden:YES];
         }
     }];
    
}

@end
