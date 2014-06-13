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
        CAShapeLayer *processBarLayer=[CAShapeLayer layer];
        UIBezierPath *processBarPath = [UIBezierPath bezierPath];
        [processBarPath moveToPoint:CGPointMake(radius,frame.size.height-1)];
        [processBarPath addArcWithCenter:CGPointMake(radius, radius) radius:radius-1 startAngle:M_PI_2 endAngle:M_PI+M_PI_2 clockwise:YES];
        [processBarPath addLineToPoint:CGPointMake(frame.size.width-radius,1)];
        [processBarPath addArcWithCenter:CGPointMake(frame.size.width-radius, radius) radius:radius-1 startAngle:M_PI+M_PI_2 endAngle:M_PI_2 clockwise:YES];
        [processBarPath addLineToPoint:CGPointMake(radius,frame.size.height-1)];
        [processBarPath closePath];
        processBarLayer.path = [processBarPath CGPath];
        processBarLayer.fillColor =[[Util colorWithHexString:@"#ffffffff"] CGColor];
        [self.viewProcessBar.layer insertSublayer:processBarLayer atIndex:0];
        [self addSubview:self.viewProcessBar];

        
        self.maskLayer=[CAShapeLayer layer];
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        [maskPath moveToPoint:CGPointMake(0,frame.size.height)];
        [maskPath addLineToPoint:CGPointMake(0,0)];
        [maskPath addLineToPoint:CGPointMake(radius,0)];
        [maskPath addLineToPoint:CGPointMake(radius,frame.size.height)];
        [maskPath closePath];
        self.maskLayer.path = [maskPath CGPath];
        self.maskLayer.fillColor =[[Util colorWithHexString:@"#ffffffff"] CGColor];
        self.viewProcessBar.layer.mask=self.maskLayer;
        
    }
    return self;
}

-(void)process:(double)per{
    double radius=self.frame.size.height/2;
    double newWidth=(self.frame.size.width-radius)*per+radius;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0,self.frame.size.height)];
    [maskPath addLineToPoint:CGPointMake(0,0)];
    [maskPath addLineToPoint:CGPointMake(newWidth,0)];
    [maskPath addLineToPoint:CGPointMake(newWidth,self.frame.size.height)];
    [maskPath closePath];
    [self.maskLayer setPath:maskPath.CGPath];
}
-(void)hide{
    self.isHiding=YES;
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setAlpha:0.0];
     } completion:^(BOOL finished) {
         if (finished){
             self.maskLayer=[CAShapeLayer layer];
             double radius=self.frame.size.height/2;
             UIBezierPath *maskPath = [UIBezierPath bezierPath];
             [maskPath moveToPoint:CGPointMake(0,self.frame.size.height)];
             [maskPath addLineToPoint:CGPointMake(0,0)];
             [maskPath addLineToPoint:CGPointMake(radius,0)];
             [maskPath addLineToPoint:CGPointMake(radius,self.frame.size.height)];
             [maskPath closePath];
             self.maskLayer.path = [maskPath CGPath];
             self.maskLayer.fillColor =[[Util colorWithHexString:@"#ffffffff"] CGColor];
             self.viewProcessBar.layer.mask=self.maskLayer;
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
