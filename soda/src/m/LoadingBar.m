//
//  LoadingBar.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LoadingBar.h"
#import "Util.h"
@implementation LoadingBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height)];
        double radius=frame.size.height/2;
        CAShapeLayer *bgLayer=[CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(radius,frame.size.height)];
        [bgPath addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
        [bgPath addLineToPoint:CGPointMake(frame.size.width-radius,0)];
        [bgPath addArcWithCenter:CGPointMake(frame.size.width-radius, radius) radius:radius startAngle:M_PI+M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [bgPath addLineToPoint:CGPointMake(radius,frame.size.height)];
        [bgPath closePath];
        bgLayer.path = [bgPath CGPath];
        bgLayer.fillColor =[[Util colorWithHexString:@"#8fc9c8ff"] CGColor];
        [self.viewBg.layer insertSublayer:bgLayer atIndex:0];
        [self addSubview:self.viewBg];
        
        self.viewProcessBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height)];
        [self.viewProcessBar setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.viewProcessBar];

        
        self.maskLayer=[CAShapeLayer layer];
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        [maskPath moveToPoint:CGPointMake(radius,frame.size.height-1)];
        [maskPath addArcWithCenter:CGPointMake(radius, radius) radius:radius-1 startAngle:M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(frame.size.width-radius,1)];
        [maskPath addArcWithCenter:CGPointMake(frame.size.width-radius, radius) radius:radius-1 startAngle:M_PI+M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [maskPath addLineToPoint:CGPointMake(radius,frame.size.height-1)];
        [maskPath closePath];
        self.maskLayer.path = [maskPath CGPath];
        self.maskLayer.fillColor =[[Util colorWithHexString:@"#ffffffff"] CGColor];
        self.viewProcessBar.layer.mask=self.maskLayer;
        self.test=[[UIView alloc]init];
        [self addSubview:self.test];
    }
    return self;
}

-(void)process:(double)per completion:(void(^)()) completion{
    double radius=self.frame.size.height/2;
    double newWidth=(self.frame.size.width-radius)*per+radius;
    [UIView animateWithDuration:0.00 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.viewProcessBar setFrame:CGRectMake(0,0, newWidth, self.frame.size.height)];
    } completion:^(BOOL finished) {
        if(finished){
            completion();
        }
    }];
    return;
}
-(void)hide{
    self.isHiding=YES;
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setAlpha:0.0];
     } completion:^(BOOL finished) {
         if (finished){
             double radius=self.frame.size.height/2;
             [self.viewProcessBar setFrame:CGRectMake(0,0, radius, self.frame.size.height)];
             [self setHidden:YES];
         }
     }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
