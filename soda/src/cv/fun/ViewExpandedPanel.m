//
//  ViewExpandedPanel.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/7.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "Util.h"

@implementation ViewExpandedPanel
@synthesize gv;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *borderLayer=[CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(self.frame.size.width, 0)];
        [linePath addLineToPoint:CGPointMake(self.frame.size.width, [GV sharedInstance].screenH)];
        borderLayer.path=linePath.CGPath;
        borderLayer.strokeColor= [Util colorWithHexString:@"#FFFFFF3F"].CGColor;
        [self.layer addSublayer:borderLayer];
        
        
        CAShapeLayer *darkBorderLayer=[CAShapeLayer layer];
        UIBezierPath *darkLinePath=[UIBezierPath bezierPath];
        [darkLinePath moveToPoint:CGPointMake(self.frame.size.width-1, 0)];
        [darkLinePath addLineToPoint:CGPointMake(self.frame.size.width-1, [GV sharedInstance].screenH)];
        darkBorderLayer.path=darkLinePath.CGPath;
        darkBorderLayer.strokeColor= [Util colorWithHexString:@"#00000020"].CGColor;
        
        [self.layer addSublayer:darkBorderLayer];
        
        self.gv=[GV sharedInstance];
    }
    return self;
}
@end
