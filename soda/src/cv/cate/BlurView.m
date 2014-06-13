//
//  BlurView.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/14.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "BlurView.h"
#import "Util.h"
#import "GV.h"

@implementation BlurView
@synthesize iphone4sBeforeBg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if([GV sharedInstance].screenH<568){
            iphone4sBeforeBg=[[ViewIphone4BgForBlurView alloc]init];
            [iphone4sBeforeBg setBackgroundColor:[Util colorWithHexString:@"#99CFCECC"]];
            [iphone4sBeforeBg setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self addSubview:iphone4sBeforeBg];
        }
    }
    return self;
}

- (void)updateAsynchronously:(BOOL)async completion:(void (^)())completion{
    if([GV sharedInstance].screenH>480){
        [super updateAsynchronously:async completion:completion];
    }
}

@end
