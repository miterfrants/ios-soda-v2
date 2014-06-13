//
//  ScrollViewProtoType.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/19.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewProtoType.h"

@implementation ScrollViewProtoType
@synthesize isCanceled;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    isCanceled=NO;
    [self.superview touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isCanceled){
        return;
    }
    [self.superview touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //unknow why touchesCancelled not pass to ScrollViewController
    //i presume scroll view delegate grap event;
    isCanceled=YES;
    [self.superview touchesCancelled:touches withEvent:event];
    [[self getViewController] touchesCancelled:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    if(location.x<0 || location.y<0 || location.x> touch.view.frame.size.width || location.y>touch.view.frame.size.height){
        [self touchesCancelled:touches withEvent:event];
        return;
    }
}

- (UIViewController*)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end
