//
//  ButtonInputForComment.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/29.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonInputForComment.h"

@implementation ButtonInputForComment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrameAndText:(CGRect) frame text:(NSString*) text{
    self=[super initWithFrame:frame];
    if(self){

        
        self.lblDefault=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.lblDefault setFont:self.gv.fontListFunctionTitle];
        [self.lblDefault setText:text];
        [self.lblDefault setTextColor:[UIColor whiteColor]];
        [self addSubview:self.lblDefault];
        
        
        self.lblShow=[[LabelForComment alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.lblShow.clickToStatus=LIST_EXPAND_WITHKEYBOARD;
        self.lblShow.originalStatus=LIST_EXPAND;
        [self.lblShow setFont:self.gv.fontListFunctionTitle];
        [self.lblShow setTextColor:[UIColor whiteColor]];
        self.lblShow.userInteractionEnabled=YES;
        [self addSubview:self.lblShow];
    }
    return self;
}
@end
