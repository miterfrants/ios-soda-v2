//
//  ButtonMenu.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMenu.h"

@implementation ButtonMenu
@synthesize name,imgViewIcon;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame name:(NSString *) pName
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *icon= [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",pName]];
        imgViewIcon =[[UIImageView alloc]init];
        [imgViewIcon setImage:icon];
        [imgViewIcon setFrame:CGRectMake(0, 0, icon.size.width/2, icon.size.height/2)];
        name=pName;
        [self addSubview:imgViewIcon];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==MENU){
        UIImage *icon=[UIImage imageNamed:[NSString stringWithFormat:@"%@_over.png", name]];
        [imgViewIcon setImage:icon];
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
    UIImage *bg=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]];
    [imgViewIcon setImage:bg];
}

@end
