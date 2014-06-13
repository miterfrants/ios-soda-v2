//
//  TextViewSearch.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "TextViewSearch.h"
#import "Util.h"
#import "DB.h"
#import "GV.h"
@implementation TextViewSearch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:CGRectMake(62, 35, 162.5, 28)];
        //self.textContainerInset = UIEdgeInsetsMake(5,5,0,0);
        UIView *padding=[[UIView alloc] init];
        UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        [padding setFrame:CGRectMake(0, 0, 10, 28)];
        self.leftView=padding;
        self.leftViewMode=UITextFieldViewModeAlways;
        [self setTextColor:[UIColor whiteColor]];
        [self setFont:font];
        [self setBackgroundColor:[Util colorWithHexString:@"FFFFFF7F"]];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:(CGSize){5, 5}].CGPath;
        self.layer.mask = maskLayer;
        [self setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    [super touchesBegan:touches withEvent:event];
    [self.superview touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(
       [GV getGlobalStatus]!=COMMON &&
       [GV getGlobalStatus]!=SEARCH
       ){
        [self resignFirstResponder];
    }
    [super touchesEnded:touches withEvent:event];
    [self.superview touchesEnded:touches withEvent:event];
}

@end
