//
//  BreadCrumbView.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "BreadCrumbView.h"

@implementation BreadCrumbView
@synthesize btnHome,btnSecond;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(62, 35, 162.5, 28)];
        btnHome =[[ButtonHome alloc]init];
        //[btnHome setBackgroundColor:[UIColor redColor]];
        [self addSubview:btnHome];
        btnSecond=[[ButtonSecond alloc]initWithFrame:CGRectMake(42, 0, 151, 28)];
        //[btnSecond setBackgroundColor:[UIColor redColor]];
        [self addSubview:btnSecond];
        //[self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}


@end
