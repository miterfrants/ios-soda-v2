//
//  ButtonSecond.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonSecond.h"
#import "Util.h"

@implementation ButtonSecond
@synthesize imgViewIcon,lblCate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        //[self.viewBg setFrame:CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height)];
        //[self setBackgroundColor:[UIColor redColor]];

        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(0, 28)];
        [bgPath addLineToPoint:CGPointMake(7, 14)];
        [bgPath addLineToPoint:CGPointMake(0, 0)];
        [bgPath addLineToPoint:CGPointMake(self.frame.size.width-5, 0)];
        [bgPath addCurveToPoint:CGPointMake(self.frame.size.width, 5) controlPoint1:CGPointMake(self.frame.size.width-2.5, 0) controlPoint2:CGPointMake(self.frame.size.width, 2.5)];
        [bgPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-5)];
        [bgPath addCurveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height) controlPoint1:CGPointMake(self.frame.size.width, self.frame.size.height-2.5) controlPoint2:CGPointMake(self.frame.size.width-2.5, self.frame.size.height)];
        [bgPath addLineToPoint:CGPointMake(0, 28)];
        [bgPath closePath];
        bgLayer.path = [bgPath CGPath];
        bgLayer.fillColor =[[Util colorWithHexString:@"0x8fC9C8FF"] CGColor];
        [bgLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.viewBg.layer addSublayer:bgLayer];
        [self addSubview:self.viewBg];
        
        imgViewIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, -20, 60, 60)];
        //[self addSubview:imgViewIcon];
        
        lblCate=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 28)];
        [lblCate setFont:self.gv.fontNormalForHebrew];
        [lblCate setTextColor:[UIColor whiteColor]];
        [lblCate setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:lblCate];
    }
    return self;
}

@end
