//
//  ButtonMail.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/21.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMail.h"

@implementation ButtonMail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self.viewBg setImage:[UIImage imageNamed:@"mail.png"]];
        [self addSubview:self.viewBg];
        self.iconNameForProtoType=@"mail.png";
        self.iconOverNameForProtoType=@"mail_over.png";
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
