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
        [lblTitle setFont:gv.fontNormalForHebrew];
        [lblMsg setFont:gv.fontHintForHebrew];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblMsg setTextColor:[UIColor darkGrayColor]];
        lblMsg.numberOfLines=100;
        viewBorder =[[UIView alloc] init];
        [self addSubview:viewBorder];
        [self addSubview:lblTitle];
        [self addSubview:lblMsg];
        [self setBackgroundColor:[UIColor redColor]];
        [self setFrame:CGRectMake(0, 0, self.gv.screenW, 200)];
        [self setHidden:YES];
    }
    return self;
}

//return up or down
-(BOOL)initWithUIView:(UIView *) target title:(NSString *) title msg:(NSString*)msg{
    [self setHidden:NO];
    CGPoint point = [target convertPoint:target.bounds.origin toView:self.window];
    [lblTitle setText:title];
    [lblMsg setText:msg];
    double padding=5;
    double borderTopBottomPadding=8;
    double borderLeftRightPadding=15;
    double edgePadding=10;
    CGSize expectedSizeOfTitle=[lblTitle sizeThatFits:CGSizeMake(self.gv.screenW-40, self.gv.screenH-20)];
    CGSize expectedSizeOfMsg=[lblMsg sizeThatFits:CGSizeMake(self.gv.screenW-40, self.gv.screenH-expectedSizeOfTitle.height-padding-40)];
    double maxWidth=expectedSizeOfTitle.width;
    if(maxWidth<expectedSizeOfMsg.width){
        maxWidth=expectedSizeOfMsg.width;
    }
    CGPoint pointOfCenter=CGPointMake(point.x+target.frame.size.width/2, point.y+target.frame.size.height/2);
    
    //tip origin x
    double tipOriginX=0;
    double tipOriginY=0;
    
    //arror
    double arrorOriginX=0;
    double arrorOriginY=0;
    
    //對話框超過螢幕
    if(pointOfCenter.x+maxWidth/2+borderLeftRightPadding>self.gv.screenW-20){
        tipOriginX=self.gv.screenW-maxWidth-edgePadding-borderLeftRightPadding*2;
    }else if(pointOfCenter.x-maxWidth/2-borderLeftRightPadding<20){
        tipOriginX=edgePadding;
    }else{
        tipOriginX=pointOfCenter.x-maxWidth/2-borderLeftRightPadding;
    }
    BOOL isUp=NO;
    if(point.y+target.frame.size.height/2>self.gv.screenH/2){
        //對畫框在物件上方
        tipOriginY=point.y+target.frame.size.height/2-expectedSizeOfTitle.height-expectedSizeOfMsg.height-padding-borderTopBottomPadding*2;
        isUp=YES;
    }else{
        //對畫框在物件下方
        tipOriginY=point.y+target.frame.size.height/2;
    }
    arrorOriginX=point.x+target.frame.size.width/2-tipOriginX;
    arrorOriginY=tipOriginY;
    
    [self setFrame:CGRectMake(tipOriginX, tipOriginY, maxWidth+borderLeftRightPadding*2, padding+borderTopBottomPadding*2+expectedSizeOfMsg.height+expectedSizeOfTitle.height)];
    
    [lblTitle setFrame:CGRectMake(borderLeftRightPadding, borderTopBottomPadding, expectedSizeOfTitle.width,expectedSizeOfTitle.height)];
    [lblMsg setFrame:CGRectMake(borderLeftRightPadding, expectedSizeOfTitle.height+borderTopBottomPadding+padding, expectedSizeOfMsg.width, expectedSizeOfMsg.height)];
    
    [self addArrowBorder:CGPointMake(arrorOriginX, arrorOriginY) size:self.frame.size isUp:isUp];
    return isUp;
}

-(void)animationPopUp:(UIView *)target title:(NSString*)title msg:(NSString*)msg{
    [self setAlpha:0];
    BOOL isUp=[self initWithUIView:target title:title msg:msg];
    self.originY=self.frame.origin.y;
    [UIView animateWithDuration:0.28 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^
     {
         [self setAlpha:1];
         double animationOffset=15;
         if(isUp){
             animationOffset=-15;
         }
         [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+animationOffset, self.frame.size.width, self.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             //NSLog(@"animation end");
         }
     }];
}

-(void)statusPreviousStatusToTip:(UIView *)target title:(NSString*)title msg:(NSString*)msg{
    gv.previousStatusForTip=[GV getGlobalStatus];
    self.targetRef=target;
    @try {
        UIView *targetView=(UIView *)target;
        if([targetView.superview isKindOfClass:[UIScrollView class]]){
            [((UIScrollView *)targetView.superview) setScrollEnabled:NO];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
    }
    [self animationPopUp:target title:title msg:msg];
    [GV setGlobalStatus:TIP];
}
-(void)statusTipToPreviousStatus{
    @try {
        UIView *targetView=(UIView *)self.targetRef;
        if([targetView.superview isKindOfClass:[UIScrollView class]]){
            [((UIScrollView *)targetView.superview) setScrollEnabled:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
    @finally {
        self.targetRef=nil;
    }
    [self animationHide];
    [GV setGlobalStatus:gv.previousStatusForTip];
}

-(void)animationHide{
    [UIView animateWithDuration:0.4 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^
     {
         [self setAlpha:0];
         [self setFrame:CGRectMake(self.frame.origin.x, self.originY, self.frame.size.width, self.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             //NSLog(@"animation end");
         }
     }];

}

-(void)addArrowBorder:(CGPoint) pointStart size:(CGSize)size isUp:(BOOL) isUp{
    viewBorder.layer.sublayers=nil;
    CAShapeLayer *layer= [CAShapeLayer layer];
    UIBezierPath *path=[UIBezierPath bezierPath];
    double radius=2.5;
    if(isUp){
        [path moveToPoint:CGPointMake(pointStart.x, size.height+8)];
        [path addLineToPoint:CGPointMake(pointStart.x+8, size.height)];
        [path addLineToPoint:CGPointMake(size.width-radius, size.height)];
        [path addArcWithCenter:CGPointMake(size.width-radius, size.height-radius) radius:radius startAngle:M_PI_2 endAngle:0 clockwise:NO];
        [path addLineToPoint:CGPointMake(size.width, radius)];
        [path addArcWithCenter:CGPointMake(size.width-radius, radius) radius:radius startAngle:0 endAngle:M_PI+M_PI_2 clockwise:NO];
        [path addLineToPoint:CGPointMake(radius, 0)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI+M_PI_2 endAngle:M_PI clockwise:NO];
        [path addLineToPoint:CGPointMake(0, size.height-radius)];
        [path addArcWithCenter:CGPointMake(radius, size.height-radius) radius:radius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
        [path addLineToPoint:CGPointMake(pointStart.x-8, size.height)];
        [path closePath];
    }else{
        [path moveToPoint:CGPointMake(pointStart.x, -8)];
        [path addLineToPoint:CGPointMake(pointStart.x+8, 0)];
        [path addLineToPoint:CGPointMake(size.width-radius, 0)];
        [path addArcWithCenter:CGPointMake(size.width-radius, radius) radius:radius startAngle:M_PI_2+M_PI endAngle:0 clockwise:YES];
        [path addLineToPoint:CGPointMake(size.width, size.height-radius)];
        [path addArcWithCenter:CGPointMake(size.width-radius, size.height-radius) radius:radius startAngle:0 endAngle:M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(radius, size.height)];
        [path addArcWithCenter:CGPointMake(radius, size.height-radius) radius:radius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        [path addLineToPoint:CGPointMake(0, radius)];
        [path addArcWithCenter:CGPointMake(radius, radius) radius:radius startAngle:M_PI endAngle:M_PI+M_PI_2 clockwise:YES];
        [path addLineToPoint:CGPointMake(pointStart.x-8, 0)];
        [path closePath];
    }
    
    
    layer.lineWidth=1.0f;
    layer.strokeColor=[UIColor whiteColor].CGColor;
    layer.fillColor=[Util colorWithHexString:@"#8dc7c6FF"].CGColor;
    layer.path=path.CGPath;
    [viewBorder setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [viewBorder.layer addSublayer:layer];
}



@end
