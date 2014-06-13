//
//  ButtonLight.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonLight.h"

@implementation ButtonLight
@synthesize imgViewFill;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"light.png"]];
        [self addSubview:self.viewBg];
        [self.viewBg setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];

        imgViewFill=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"light_fill.png"]];
        [self addSubview:imgViewFill];
        [imgViewFill setFrame:CGRectMake(22, 22, 0, 0)];
        
        self.name=@"opening";
    }
    return self;
}

-(void)turnOn{
    [self animationToFill];
}
-(void)turnOff{
    [self.viewBg setImage:[UIImage imageNamed:@"light.png"]];
}
-(void) animationToFill{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [imgViewFill setFrame:CGRectMake(0, 0, 44, 44)];
         } completion:^(BOOL finished) {
             if (finished){
             }
         }];
    });
}

-(void) animationToEmpty{
    [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [imgViewFill setFrame:CGRectMake(22, 22, 0, 0)];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}

@end
