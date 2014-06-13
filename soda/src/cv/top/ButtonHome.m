//
//  ButtonHome.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonHome.h"
#import "Util.h"
@implementation ButtonHome
@synthesize imgViewIcon;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 45, 28)];
        self.viewBg =[[UIImageView alloc]init];
        [self.viewBg setFrame:CGRectMake(0, 0, 45, 28)];
        [self addSubview:self.viewBg];
        
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPath];
        [bgPath moveToPoint:CGPointMake(0, 5)];
        [bgPath addCurveToPoint:CGPointMake(5, 0) controlPoint1:CGPointMake(0, 2.5) controlPoint2:CGPointMake(2.5, 0)];
        [bgPath addLineToPoint:CGPointMake(38, 0)];
        [bgPath addLineToPoint:CGPointMake(45, 14)];
        [bgPath addLineToPoint:CGPointMake(38, 28)];
        [bgPath addLineToPoint:CGPointMake(5, 28)];
        [bgPath addCurveToPoint:CGPointMake(0, 23) controlPoint1:CGPointMake(2.5, 28) controlPoint2:CGPointMake(0, 25.5)];
        [bgPath addLineToPoint:CGPointMake(0, 5)];
        [bgPath closePath];
        bgLayer.path = [bgPath CGPath];
        bgLayer.fillColor =[[Util colorWithHexString:@"0xb0d5d4FF"] CGColor];
        [bgLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        [self.viewBg.layer addSublayer:bgLayer];
        imgViewIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home.png"]];
        [imgViewIcon setFrame:CGRectMake(-2, -8, 44, 44)];
        [self addSubview:imgViewIcon];
    }
    return self;
}

@end
