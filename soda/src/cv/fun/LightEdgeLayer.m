//
//  LightEdgeLayer.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LightEdgeLayer.h"
#import "Util.h"
@implementation LightEdgeLayer
-(LightEdgeLayer *) iniSelf{
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(0, 0)];
    [linePath addLineToPoint:CGPointMake(51.5, 0)];
    self.path=linePath.CGPath;
    self.strokeColor = [Util colorWithHexString:@"#FFFFFF3F"].CGColor;
    return self;
}
@end
