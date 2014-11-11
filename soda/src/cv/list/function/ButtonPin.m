//
//  ButtonPin.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonPin.h"

@implementation ButtonPin

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"showmap.png"]];
        [self.viewBg setFrame:CGRectMake(0, 0,self.viewBg.frame.size.width/2, self.viewBg.frame.size.height/2)];
        [self addSubview:self.viewBg];
    }
    return self;
}


-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==LIST){
        UIImage *bg=[UIImage imageNamed:@"showmap_over.png"];
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
    UIImage *bg=[UIImage imageNamed:@"showmap.png"];
    [self.viewBg setImage:bg];
}
@end
