//
//  ButtonRoundedCorner.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonRoundedCorner.h"
#import "Util.h"
#import "GV.h"

@implementation ButtonRoundedCorner
@synthesize lblTitle,originFrame;
- (id)initWithFrame:(CGRect)frame buttonTitle:(NSString*) buttonTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=buttonTitle;
        [lblTitle setFont:self.gv.contentFont];
        [lblTitle setTextColor:[Util colorWithHexString:@"#419291FF"]];
        [lblTitle setFrame:CGRectMake(0, 0, 130, 30)];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lblTitle];
        
        
        self.originFrame=frame;
        
        [self setBackgroundColor:[Util colorWithHexString:@"#FFFFFF"]];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:(CGSize){5, 5}].CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==MENU){
        [self setBackgroundColor:[Util colorWithHexString:@"#419291FF"]];
        [self.lblTitle setTextColor:[UIColor whiteColor]];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}


-(void)toUnHighLightStatus{
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.lblTitle setTextColor:[Util colorWithHexString:@"#419291FF"]];
}
@end
