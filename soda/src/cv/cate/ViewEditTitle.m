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

- (id)initWithFrameAndKey:(CGRect)frame titleKey:(NSString*) titleKey
{
    self = [super initWithFrame:frame];
    if (self) {
        int padding=10;

        
        lblDisplayTitle = [[LabelForChangeUILang alloc]init];
        UIFont *font=[GV sharedInstance].titleFont;
        lblDisplayTitle.key=titleKey;
        [lblDisplayTitle setTextColor:[Util colorWithHexString:@"#419291FF"]];
        [lblDisplayTitle setFont:font];
        [lblDisplayTitle setLineBreakMode:NSLineBreakByWordWrapping];
        CGSize labelSize=[lblDisplayTitle sizeThatFits:CGSizeMake(28, 100)];
        [lblDisplayTitle setFrame:CGRectMake(padding
                                             , 0, labelSize.width, 28)];
        [self addSubview:lblDisplayTitle];

        //txt
        txtContent =[[TextFieldEditIconTitle alloc] initWithFrame:CGRectMake(padding*2+labelSize.width+8, 0, 200, 28)];
        [self addSubview:txtContent];
        
        self.bg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.bg];
        [self setFrame:CGRectMake(0, self.frame.origin.y, self.gv.screenW, 28)];

    }
    return self;
}

-(void)repose:(double)labelWidth{
    self.bg.layer.sublayers=nil;
    double circleRadius=7;
    double radius=8;
    int padding=10;
    
    //white circle
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(circleRadius,circleRadius) radius:circleRadius startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = [path CGPath];
    layer.fillColor = [[UIColor whiteColor] CGColor];
    [layer setFrame:CGRectMake(padding*2+labelWidth+1,circleRadius, circleRadius*2, circleRadius*2)];
    [self.bg.layer addSublayer:layer];
    
    //cornner border
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    
    [bgPath moveToPoint:CGPointMake(0, 5)];
    [bgPath addCurveToPoint:CGPointMake(5, 0) controlPoint1:CGPointMake(0, 2.5) controlPoint2:CGPointMake(2.5, 0)];
    
    [bgPath addLineToPoint:CGPointMake(padding*2+labelWidth+radius, 0)];
    [bgPath addLineToPoint:CGPointMake(padding*2+labelWidth+radius, self.frame.size.height/2-radius)];
    [bgPath addCurveToPoint:CGPointMake(padding*2+labelWidth, self.frame.size.height/2) controlPoint1:CGPointMake(padding*2+labelWidth+radius/2 , self.frame.size.height/2-radius) controlPoint2:CGPointMake(padding*2+labelWidth, self.frame.size.height/2-radius/2)];
    [bgPath addCurveToPoint:CGPointMake(padding*2+labelWidth+radius, self.frame.size.height/2+radius) controlPoint1:CGPointMake(padding*2+labelWidth , self.frame.size.height/2+radius/2) controlPoint2:CGPointMake(padding*2+labelWidth+radius/2, self.frame.size.height/2+radius)];
    [bgPath addLineToPoint:CGPointMake(padding*2+labelWidth+radius, self.frame.size.height)];
    [bgPath addLineToPoint:CGPointMake(5, self.frame.size.height)];
    [bgPath addCurveToPoint:CGPointMake(0, self.frame.size.height-5) controlPoint1:CGPointMake(2.5, self.frame.size.height) controlPoint2:CGPointMake(0, self.frame.size.height-2.5)];
    [bgPath addLineToPoint:CGPointMake(0, 5)];
    [bgPath closePath];
    bgLayer.path=[bgPath CGPath];
    bgLayer.fillColor =[[UIColor whiteColor] CGColor];
    [self.bg.layer addSublayer:bgLayer];
    [lblDisplayTitle setFrame:CGRectMake(lblDisplayTitle.frame.origin.x, lblDisplayTitle.frame.origin.y, labelWidth, lblDisplayTitle.frame.size.height)];
    [self bringSubviewToFront:lblDisplayTitle];
    [txtContent setFrame:CGRectMake(padding*2+lblDisplayTitle.frame.size.width+8, 0, 200, 28)];
    
    [self setFrame:CGRectMake((self.gv.screenW-(padding*2+lblDisplayTitle.frame.size.width+8+200))/2, self.frame.origin.y, self.gv.screenW, 28)];
}
@end
