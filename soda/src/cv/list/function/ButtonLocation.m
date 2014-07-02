//
//  ButtonLocation.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonLocation.h"
#import "Util.h"
#import "DB.h"
@implementation ButtonLocation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrameAndName:frame title:[DB getUI:@"location"]];
    if (self) {
    }
    return self;
}




@end
