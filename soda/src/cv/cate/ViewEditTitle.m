//
//  ViewLeftOfTextFieldEditionTitle.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewEditTitle.h"
#import "TextFieldEditIconTitle.h"
#import "Util.h"
#import "GV.h"

@implementation ViewEditTitle
@synthesize lblDisplayTitle,txtContent;

- (id)initWithFrame:(CGRect)frame minWidth:(double) minWidth title:(NSString*) title
{
    self = [super initWithFrame:frame];
    if (self) {
        int padding=10;
        double circleRadius=7;
        double radius=8;
        
        //white circle
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(circleRadius,circleRadius) radius:circleRadius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = [path CGPath];
        layer.fillColor = [[UIColor whiteColor] CGColor];
        [layer setFrame:CGRectMake(padding*2+minWidth+1,circleRadius, circleRadius*2, circleRadius*2)];
        [self.layer addSublayer:layer];
        
        //cornner border
        CAShapeLayer *bgLayer = [CAShapeLayer layer];
        UIBezierPath *bgPath = [UIBezierPath bezierPath];

        [bgPath moveToPoint:CGPointMake(0, 5)];
        [bgPath addCurveToPoint:CGPointMake(5, 0) controlPoint1:CGPointMake(0, 2.5) controlPoint2:CGPointMake(2.5, 0)];

        [bgPath addLineToPoint:CGPointMake(padding*2+minWidth+radius, 0)];
        [bgPath addLineToPoint:CGPointMake(padding*2+minWidth+radius, frame.size.height/2-radius)];
        [bgPath addCurveToPoint:CGPointMake(padding*2+minWidth, frame.size.height/2) controlPoint1:CGPointMake(padding*2+minWidth+radius/2 , frame.size.height/2-radius) controlPoint2:CGPointMake(padding*2+minWidth, frame.size.height/2-radius/2)];
        [bgPath addCurveToPoint:CGPointMake(padding*2+minWidth+radius, frame.size.height/2+radius) controlPoint1:CGPointMake(padding*2+minWidth , frame.size.height/2+radius/2) controlPoint2:CGPointMake(padding*2+minWidth+radius/2, frame.size.height/2+radius)];
        [bgPath addLineToPoint:CGPointMake(padding*2+minWidth+radius, frame.size.height)];
        [bgPath addLineToPoint:CGPointMake(5, frame.size.height)];
        [bgPath addCurveToPoint:CGPointMake(0, frame.size.height-5) controlPoint1:CGPointMake(2.5, frame.size.height) controlPoint2:CGPointMake(0, frame.size.height-2.5)];
        [bgPath addLineToPoint:CGPointMake(0, 5)];
        [bgPath closePath];
        bgLayer.path=[bgPath CGPath];
        bgLayer.fillColor =[[UIColor whiteColor] CGColor];
        [self.layer addSublayer:bgLayer];
        

        
        lblDisplayTitle = [[UILabel alloc]init];
        UIFont *font=[GV sharedInstance].titleFont;
        [lblDisplayTitle setText:title];
        [lblDisplayTitle setTextColor:[Util colorWithHexString:@"#419291FF"]];
        [lblDisplayTitle setFont:font];
        [lblDisplayTitle setLineBreakMode:NSLineBreakByWordWrapping];
        CGSize labelSize=[lblDisplayTitle.text sizeWithAttributes: @{NSFontAttributeName:font}];

        [lblDisplayTitle setFrame:CGRectMake(minWidth-labelSize.width+padding
                                             , 0, labelSize.width, 28)];
        [self addSubview:lblDisplayTitle];

        //txt
        txtContent =[[TextFieldEditIconTitle alloc] initWithFrame:CGRectMake(padding*2+minWidth+8, 0, 200, 28)];
        [self addSubview:txtContent];

    }
    return self;
}
@end
