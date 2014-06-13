//
//  ButtonFlag.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonFlag.h"

@implementation ButtonFlag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"official_flag.png"]];
        [self addSubview:self.viewBg];
        [self.viewBg setFrame:CGRectMake(0, -3, frame.size.width, frame.size.height)];
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
