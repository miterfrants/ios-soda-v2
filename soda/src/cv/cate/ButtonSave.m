//
//  ButtonSave.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonSave.h"
#import "GV.h"

@implementation ButtonSave
@synthesize imgViewIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        GV* gv=[GV sharedInstance];
        imgViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save.png"]];
        [imgViewIcon setFrame:CGRectMake(0, 0, 44, 44)];
        [self setFrame:CGRectMake(gv.screenW-28.5-24,-12, 44, 44)];
        [self addSubview:imgViewIcon];
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [imgViewIcon setImage:[UIImage imageNamed:@"save_over.png"]];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLight) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)toUnHighLight{
    [imgViewIcon setImage:[UIImage imageNamed:@"save.png"]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [imgViewIcon setImage:[UIImage imageNamed:@"save.png"]];
    [super touchesCancelled:touches withEvent:event];
}

@end
