//
//  ButtonRemoteCate.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/9.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonRemoveCate.h"

@implementation ButtonRemoveCate

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bg=[UIImage imageNamed:@"remove.png"];
        self.viewBg= [[UIImageView alloc] initWithImage:bg];
        [self.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:self.viewBg];
    }
    return self;
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==EDIT_WITH_KEYBOARD || [GV getGlobalStatus] == EDIT_WITHOUT_KEYBOARD){
        UIImage *bg=[UIImage imageNamed:@"remove_over.png"];
        [self.viewBg setImage:bg];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}


-(void)toUnHighLightStatus{
    UIImage *bg=[UIImage imageNamed:@"remove.png"];
    [self.viewBg setImage:bg];
}

@end
