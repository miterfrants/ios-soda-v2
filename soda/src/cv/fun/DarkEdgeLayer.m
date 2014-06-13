//
//  DarkEdgeLayer.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "DarkEdgeLayer.h"
#import "Util.h"

@implementation DarkEdgeLayer

-(DarkEdgeLayer *) iniSelf{
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(51.5, 0)];
    self.path=linePath.CGPath;
    self.strokeColor = [Util colorWithHexString:@"#00000020"].CGColor;
    return self;
}
@end
