//
//  ViewArrow.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/26.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewArrow.h"

@implementation ViewArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *shape=[CAShapeLayer layer];
        UIBezierPath *path=[UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, frame.size.height)];
        [path addLineToPoint:CGPointMake(frame.size.width/2,0)];
        [path addLineToPoint:CGPointMake(frame.size.width,frame.size.height)];
        [path closePath];
        shape.fillColor=[UIColor whiteColor].CGColor;
        shape.path=path.CGPath;
        [self.layer addSublayer:shape];
    }
    return self;
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
