//
//  ButtonKeyboardTopDone.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/29.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonKeyboardTopDone.h"
#import "Util.h"
@implementation ButtonKeyboardTopDone

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.lblTitle setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lblTitle];
        [self.lblTitle setFont:self.gv.fontButtonText];
        [self.lblTitle setTextColor:[Util colorWithHexString:@"#263439FF"]];
        [self.lblTitle setText:@"done"];
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
