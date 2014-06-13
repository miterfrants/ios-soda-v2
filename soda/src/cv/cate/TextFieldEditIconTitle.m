//
//  TextFieldEditIconTitle.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "TextFieldEditIconTitle.h"
#import "Util.h"
#import "GV.h"
#import "PaddingViewForEditIcon.h"
//reference by ViewEditTitle 
@implementation TextFieldEditIconTitle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        double radius= 8;

        [self setFrame:frame];
        [self setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [self setTextColor:[Util colorWithHexString:@"#419291FF"]];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *pathBg= [UIBezierPath bezierPath];
        [pathBg moveToPoint:CGPointMake(0, 0)];
        [pathBg addLineToPoint:CGPointMake(frame.size.width-5, 0)];
        [pathBg addCurveToPoint:CGPointMake(frame.size.width, 5) controlPoint1:CGPointMake(frame.size.width-2.5, 0) controlPoint2:CGPointMake(frame.size.width,2.5)];
        [pathBg addLineToPoint:CGPointMake(frame.size.width, frame.size.height-5)];
        [pathBg addCurveToPoint:CGPointMake(frame.size.width-5, frame.size.height) controlPoint1:CGPointMake(frame.size.width, frame.size.height-2.5) controlPoint2:CGPointMake(frame.size.width-2.5, frame.size.height)];
        [pathBg addLineToPoint:CGPointMake(0, frame.size.height)];
        [pathBg addLineToPoint:CGPointMake(0, frame.size.height/2+radius)];
        [pathBg addCurveToPoint:CGPointMake(radius, frame.size.height/2) controlPoint1:CGPointMake(radius/2, frame.size.height/2+radius) controlPoint2:CGPointMake(radius, frame.size.height/2+radius/2)];
        [pathBg addCurveToPoint:CGPointMake(0, frame.size.height/2-radius) controlPoint1:CGPointMake(radius, frame.size.height/2-radius/2) controlPoint2:CGPointMake(radius/2, frame.size.height/2-radius)];

        [pathBg addLineToPoint:CGPointMake(0, 0)];
        [pathBg closePath];
        maskLayer.path = [pathBg CGPath];
        maskLayer.fillColor =[[Util colorWithHexString:@"0xFFFFFF7F"] CGColor];
        [maskLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.layer addSublayer:maskLayer];
        
        PaddingViewForEditIcon *padding=[[PaddingViewForEditIcon alloc]init];
        [padding setFrame:CGRectMake(0, 0, 10+radius, 28)];
        self.leftView=padding;
        self.leftViewMode=UITextFieldViewModeAlways;
        
        [self setTintColor:[Util colorWithHexString:@"#419291FF"]];

    }
    return self;
}

@end
