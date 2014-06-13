//
//  SingleHeart.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/27.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "SingleHeart.h"

@implementation SingleHeart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heart.png"]];
        [self addSubview:self.viewBg];
        [self.viewBg setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        self.viewImgFillHeart =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heart_fill.png"]];
        [self addSubview:self.viewImgFillHeart];
        [self.viewImgFillHeart setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.transformRate=frame.size.width/44;
    }
    return self;
}
//0-1
-(void) setRate:(float) rate{
    //NSLog(@"rate:%f",rate);
    float fillHeight=rate*18;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0, (44-13)*self.transformRate)];
    [maskPath addLineToPoint:CGPointMake(44, (44-13)*self.transformRate)];
    [maskPath addLineToPoint:CGPointMake(44, (44-13-fillHeight)*self.transformRate)];
    [maskPath addLineToPoint:CGPointMake(0, (44-13-fillHeight)*self.transformRate)];
    [maskPath addLineToPoint:CGPointMake(0, (44-13)*self.transformRate)];
    [maskPath closePath];
    maskLayer.path =[maskPath CGPath];
    maskLayer.fillColor=[UIColor redColor].CGColor;
    //[viewImgFillHeart.layer addSublayer:maskLayer];
    [self.viewImgFillHeart.layer setMask:maskLayer];
}

@end
