//
//  CustomizeInfoWindow.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/3.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "CustomizeInfoWindow.h"
#import "Util.h"
@implementation CustomizeInfoWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lblName=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [self.lblName setFont:self.gv.fontInfoWindowTitle];
        self.lblName.numberOfLines=3;
        [self.lblName setTextColor:[UIColor blackColor]];
        [self addSubview:self.lblName];
        
        self.lblDistance=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.lblDistance setFont:self.gv.fontInfoWindowDistance];
        self.lblDistance.numberOfLines=3;
        [self.lblDistance setTextColor:[UIColor darkGrayColor]];
        [self addSubview:self.lblDistance];
        
        self.lblAddress=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.lblAddress setFont:self.gv.fontInfoWindowDistance];
        self.lblAddress.numberOfLines=3;
        [self.lblAddress setTextColor:[UIColor darkGrayColor]];
        [self addSubview:self.lblAddress];
        
    }
    return self;
}

-(void) initial{
    CGSize expectedNameSize =[self.lblName sizeThatFits:CGSizeMake(self.gv.screenW-20, 20)];
    [self.lblName setFrame:CGRectMake(20, 15, expectedNameSize.width, expectedNameSize.height)];
    CGSize expectedDistanceSize =[self.lblDistance sizeThatFits:CGSizeMake(self.gv.screenW-20, 20)];
    [self.lblDistance  setFrame:CGRectMake(20, self.lblName.frame.origin.y+self.lblName.frame.size.height+3, expectedDistanceSize.width, expectedDistanceSize.height)];
    CGSize expectedAddressSize =[self.lblAddress sizeThatFits:CGSizeMake(self.gv.screenW-20, 20)];
    [self.lblAddress  setFrame:CGRectMake(20, self.lblDistance.frame.origin.y+self.lblDistance.frame.size.height+3, expectedAddressSize.width, expectedAddressSize.height)];
    double maxWidth=expectedAddressSize.width;
    if(expectedNameSize.width>maxWidth){
        maxWidth=expectedNameSize.width;
    }else if(expectedDistanceSize.width>maxWidth){
        maxWidth=expectedDistanceSize.width;
    }
    [self setFrame:CGRectMake(0, 0, maxWidth+20+20, expectedNameSize.height+expectedAddressSize.height+expectedDistanceSize.height+10+3+3+20+20)];
    
    CAShapeLayer *bgLayer=[CAShapeLayer layer];
    UIBezierPath *bgPath = [UIBezierPath bezierPath];
    [bgPath moveToPoint:CGPointMake(10, 15)];
    [bgPath addArcWithCenter:CGPointMake(15, 15) radius:5 startAngle:M_PI endAngle:M_PI+M_PI_2 clockwise:YES];
    [bgPath addLineToPoint:CGPointMake(self.frame.size.width-15, 10)];
    [bgPath addArcWithCenter:CGPointMake(self.frame.size.width-15, 15) radius:5 startAngle:M_PI+M_PI_2 endAngle:0 clockwise:YES];
    [bgPath addLineToPoint:CGPointMake(self.frame.size.width-10, self.frame.size.height-15)];
    [bgPath addArcWithCenter:CGPointMake(self.frame.size.width-15, self.frame.size.height-15) radius:5 startAngle:0 endAngle:M_PI_2 clockwise:YES];

    [bgPath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height-10) radius:14 startAngle:0 endAngle:-M_PI clockwise:NO];
    [bgPath addLineToPoint:CGPointMake(15, self.frame.size.height-10)];
    
    [bgPath addArcWithCenter:CGPointMake(15, self.frame.size.height-15) radius:5 startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [bgPath addLineToPoint:CGPointMake(10, 15)];

    [bgPath closePath];
    bgLayer.path = [bgPath CGPath];
    bgLayer.fillColor =[[Util colorWithHexString:@"#FFFFFFFF"] CGColor];
    bgLayer.strokeColor=[[Util colorWithHexString:@"#CCCCCCFF"] CGColor];

    [self.layer insertSublayer:bgLayer atIndex:0];
    self.layer.shadowOffset = CGSizeMake(1.0f,3.0f);
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor;
    self.layer.shadowPath=bgPath.CGPath;

}
@end
