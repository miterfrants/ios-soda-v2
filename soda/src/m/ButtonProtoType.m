//
//  ButtonProtoType.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"

@implementation ButtonProtoType
@synthesize isCanceled,highlightTimer,viewBg,gv;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    if(self.iconOverNameForProtoType!=nil){
        [self.viewBg setImage:[UIImage imageNamed:self.iconOverNameForProtoType]];
    }
    isCanceled=NO;
    [self.superview touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if(self.iconNameForProtoType!=nil && self.iconNameForProtoType.length>0){
        [self.highlightTimer invalidate];
        self.highlightTimer=nil;
        self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightForProtoType) userInfo:nil repeats:NO];
    }
    if(isCanceled){
        return;
    }
    UIViewController *controller=[self getViewController];
    if(controller!=nil){
        [[self getViewController] touchesEnded:touches withEvent:event];
    }else{
        [self.superview touchesEnded:touches withEvent:event];
    }


}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.iconNameForProtoType!=nil && self.iconNameForProtoType.length>0){
        [self.highlightTimer invalidate];
        self.highlightTimer=nil;
        self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightForProtoType) userInfo:nil repeats:NO];
    }
    isCanceled=YES;
    [self.superview touchesCancelled:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if(location.x<0 || location.y<0 || location.x> touch.view.frame.size.width || location.y>touch.view.frame.size.height){
        [self touchesCancelled:touches withEvent:event];
        return;
    }
}
- (UIViewController*)getViewController
{
    UIResponder* nextResponder = [self.superview nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        return (UIViewController *)nextResponder;
    }
    return nil;
}

-(void)toUnHighLightForProtoType{
    [self.viewBg setImage:[UIImage imageNamed:self.iconNameForProtoType]];
}


@end
