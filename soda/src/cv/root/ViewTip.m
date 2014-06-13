//
//  ViewTip.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewTip.h"
#import "GV.h"
#import "Util.h"

@implementation ViewTip
@synthesize viewArrowBorder,lblMsg,lblTitle,gv,viewBorder;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gv=[GV sharedInstance];
        viewArrowBorder=[[UIView alloc]init];
        [self addSubview:viewArrowBorder];
        lblMsg =[[UILabel alloc] init];
        lblTitle=[[UILabel alloc]init];
        [lblTitle setFont:gv.tipTitleFont];
        [lblMsg setFont:gv.tipMsgFont];
        [lblTitle setTextColor:[Util colorWithHexString:@"#FFFFFFFF"]];
        [lblMsg setTextColor:[Util colorWithHexString:@"#FFFFFFFF"]];
        viewBorder =[[UIView alloc] init];
        [self addSubview:viewBorder];
        [self addSubview:lblTitle];
        [self addSubview:lblMsg];

    }
    return self;
}

-(void)initWithUIView:(UIView *) target title:(NSString *) title msg:(NSString*)msg{
    CGPoint point = [target convertPoint:target.bounds.origin toView:self.window];
    //CGSize msgSize=[msg sizeWithAttributes: @{NSFontAttributeName:font}];

    CGRect msgRect=[msg boundingRectWithSize:CGSizeMake(197, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:gv.tipMsgFont} context:nil];
    CGRect titleRect=[msg boundingRectWithSize:CGSizeMake(197, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:gv.tipTitleFont} context:nil];
    
    double padding=15;
    [lblTitle setFrame:CGRectMake(padding, padding/2, 197, titleRect.size.height)];
    [lblMsg setFrame:CGRectMake(padding, titleRect.size.height+17, msgRect.size.width, msgRect.size.height)];
    

    [lblTitle setText:title];
    [lblMsg setText:msg];
    
    CGPoint destPoint=CGPointMake(point.x+target.frame.size.width+padding, point.y+target.frame.size.height/2);
    
    CGSize destSize=CGSizeMake(0, padding+titleRect.size.height+padding+msgRect.size.height+padding);
    [self setFrame:CGRectMake(destPoint.x-22.5, destPoint.y-destSize.height/2, 197, destSize.height)];
    //[self setBackgroundColor:[Util colorWithHexString:@"#8dc7c6FF"]];
    
    [self addArrowBorder];
}

-(void)animationPopUp:(UIView *)target title:(NSString*)title msg:(NSString*)msg{
    [self setAlpha:0];
    [self initWithUIView:target title:title msg:msg];
    [UIView animateWithDuration:0.28 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^
     {
         [self setAlpha:1];
         [self setFrame:CGRectMake(self.frame.origin.x+15, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             //NSLog(@"animation end");
         }
     }];
}

-(void)statusPreviousStatusToTip:(UIView *)target title:(NSString*)title msg:(NSString*)msg{
    gv.previousStatusForTip=[GV getGlobalStatus];
    [self animationPopUp:target title:title msg:msg];
    [GV setGlobalStatus:TIP];
}
-(void)statusTipToPreviousStatus{
    [self animationHide];
    [GV setGlobalStatus:gv.previousStatusForTip];
}

-(void)animationHide{
    [UIView animateWithDuration:0.4 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^
     {
         [self setAlpha:0];
         [self setFrame:CGRectMake(self.frame.origin.x-15, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             //NSLog(@"animation end");
         }
     }];

}

-(void)addArrowBorder{
    viewBorder.layer.sublayers=nil;
    CAShapeLayer *layer= [CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(7.5, self.frame.size.height/2-7.5)];
    [path addLineToPoint:CGPointMake(7.5, 5)];
    [path addCurveToPoint:CGPointMake(12.5, 0) controlPoint1:CGPointMake(7.5, 2.5) controlPoint2:CGPointMake(10, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-5, 0)];
    [path addCurveToPoint:CGPointMake(self.frame.size.width, 5) controlPoint1:CGPointMake(self.frame.size.width-2.5, 0) controlPoint2:CGPointMake(self.frame.size.width, 2.5)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-5)];
    [path addCurveToPoint:CGPointMake(self.frame.size.width-5, self.frame.size.height) controlPoint1:CGPointMake(self.frame.size.width, self.frame.size.height-2.5) controlPoint2:CGPointMake(self.frame.size.width-2.5, self.frame.size.height)];
    [path addLineToPoint:CGPointMake(12.5, self.frame.size.height)];
    [path addCurveToPoint:CGPointMake(7.5, self.frame.size.height-5) controlPoint1:CGPointMake(10, self.frame.size.height) controlPoint2:CGPointMake(7.5, self.frame.size.height-2.5)];
    [path addLineToPoint:CGPointMake(7.5, self.frame.size.height/2+7.5)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height/2)];
    layer.lineWidth=1.0f;
    layer.strokeColor=[UIColor whiteColor].CGColor;
    layer.fillColor=[Util colorWithHexString:@"#8dc7c6FF"].CGColor;
    layer.path=path.CGPath;
    [viewBorder setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [viewBorder.layer addSublayer:layer];
}



@end
