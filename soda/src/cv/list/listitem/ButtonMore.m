//
//  ButtonMore.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMore.h"

@implementation ButtonMore

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.lblTitle];
        [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
        [self.lblTitle setFont:self.gv.fontListFunctionTitle];
        [self.lblTitle setTextColor:[UIColor whiteColor]];
        [self.lblTitle setText:@"More"];
    }
    return self;
}

@end
