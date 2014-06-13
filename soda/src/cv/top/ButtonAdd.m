//
//  ButtonPin.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonAdd.h"
#import "GV.h"
@implementation ButtonAdd
@synthesize viewBg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bg=[UIImage imageNamed:@"add.png"];
        viewBg= [[UIImageView alloc] initWithImage:bg];
        [viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:viewBg];
        [self setFrame:CGRectMake(258, 27, 44, 44)];
    }
    return self;
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==COMMON || [GV getGlobalStatus] == SEARCH){
        UIImage *bg=[UIImage imageNamed:@"add_over.png"];
        [viewBg setImage:bg];
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
    UIImage *bg=[UIImage imageNamed:@"add.png"];
    [viewBg setImage:bg];
}

@end
