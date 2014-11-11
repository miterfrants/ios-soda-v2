//
//  LabelForChangeUILang.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/7/8.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LabelForChangeUILang.h"
#import "DB.h"

@implementation LabelForChangeUILang

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
    }
    return self;
}

-(void) setKey:(NSString *)value{
    self.text=[DB getUI:value];
    [self.gv.arrLabelForChangeUILang addObject:self];
    _key=value;
}

-(void)changeLang{
    self.text=[DB getUI:self.key];
    if(self.parentView && self.completeInvoke){
        [self.parentView performSelectorOnMainThread:self.completeInvoke withObject:nil waitUntilDone:YES];
    }
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
