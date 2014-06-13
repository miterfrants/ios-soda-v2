//
//  ScrollViewExpandPanel.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/24.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewExpandPanel.h"
#import "Util.h"
#import "GV.h"

@implementation ScrollViewExpandPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *borderLayer=[CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(self.frame.size.width, 0)];
        [linePath addLineToPoint:CGPointMake(self.frame.size.width, [GV sharedInstance].screenH)];
        borderLayer.path=linePath.CGPath;
        borderLayer.strokeColor= [Util colorWithHexString:@"#9ed1d0FF"].CGColor;
        [self.layer addSublayer:borderLayer];
        
        
        CAShapeLayer *darkBorderLayer=[CAShapeLayer layer];
        UIBezierPath *darkLinePath=[UIBezierPath bezierPath];
        [darkLinePath moveToPoint:CGPointMake(self.frame.size.width-1, 0)];
        [darkLinePath addLineToPoint:CGPointMake(self.frame.size.width-1, [GV sharedInstance].screenH)];
        darkBorderLayer.path=darkLinePath.CGPath;
        darkBorderLayer.strokeColor= [Util colorWithHexString:@"#78b6b5FF"].CGColor;
        
        [self.layer addSublayer:darkBorderLayer];
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
