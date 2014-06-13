//
//  ButtonSendSuggestion.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonSendSuggestion.h"
#import "Util.h"
#import "DB.h"

@implementation ButtonSendSuggestion
@synthesize isSending;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isSending){
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isSending){
        return;
    }
    NSLog(@"%@",@"touchesEnded");
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(isSending){
        return;
    }
    [super touchesCancelled:touches withEvent:event];
}

-(void)changeToSendingStatus{
    isSending=YES;
    [self.highlightTimer invalidate];
    [self setBackgroundColor:[Util colorWithHexString:@"#419291FF"]];
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblTitle setText:[DB getUI:@"sending"]];
}

-(void)changeToCommonStatus{
    isSending=NO;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.lblTitle setText:[DB getUI:@"send"]];
    [self.lblTitle setTextColor:[Util colorWithHexString:@"#419291FF"]];
}

-(void)changeToFinishStatus{
    [self.lblTitle setText:[DB getUI:@"sent_finish"]];
}
@end
