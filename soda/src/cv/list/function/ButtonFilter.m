//
//  ButtonFilter.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonFilter.h"
#import "DB.h"
@implementation ButtonFilter
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrameAndName:frame title:[DB getUI:@"filter"]];
    if (self) {
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
