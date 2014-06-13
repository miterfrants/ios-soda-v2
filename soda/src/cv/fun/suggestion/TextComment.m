//
//  TextComment.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "TextComment.h"

@implementation TextComment
@synthesize originFrame;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.originFrame=frame;
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
