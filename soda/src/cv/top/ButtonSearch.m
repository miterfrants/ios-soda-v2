//
//  ButtonSearch.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonSearch.h"
#import "Util.h"
#import "GV.h"

@implementation ButtonSearch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bg=[UIImage imageNamed:@"search.png"];
        UIImageView *viewBg= [[UIImageView alloc] initWithImage:bg];
        [viewBg setFrame:CGRectMake(9, 7.7, 13.5, 13.5)];
        [self addSubview:viewBg];
        [self setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7F"]];
        [self setFrame:CGRectMake(225.5, 35, 30, 28)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:(CGSize){5, 5}].CGPath;
        self.layer.mask = maskLayer;
        
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==COMMON || [GV getGlobalStatus] == SEARCH){
        [self setBackgroundColor:[Util colorWithHexString:@"#263439FF"]];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}

-(void)toUnHighLightStatus{
    [self setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7F"]];
}

@end
