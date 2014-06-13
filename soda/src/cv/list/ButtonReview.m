//
//  ButtonReview.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonReview.h"

@implementation ButtonReview
@synthesize viewImgFillHeart,lblCountOfReview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heart.png"]];
        [self addSubview:self.viewBg];
        [self.viewBg setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        viewImgFillHeart =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"heart_fill.png"]];
        [self addSubview:viewImgFillHeart];
        [viewImgFillHeart setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        lblCountOfReview=[[UILabel alloc]init];
        [lblCountOfReview setFont:self.gv.fontCountOfReview];
        [lblCountOfReview setTextColor:[UIColor whiteColor]];
        [lblCountOfReview setFrame:CGRectMake(40, 2, 6, 10)];
        [lblCountOfReview setText:@"0"];
        [self addSubview: lblCountOfReview];
        self.name=@"review";
    }
    return self;
}

-(void) setRate:(float) rate{
    //NSLog(@"rate:%f",rate);
    if(rate==0){
        [viewImgFillHeart setHidden:YES];
        return;
    }
    float fillHeight=rate/5*18;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    [maskPath moveToPoint:CGPointMake(0, 44-13)];
    [maskPath addLineToPoint:CGPointMake(44, 44-13)];
    [maskPath addLineToPoint:CGPointMake(44, 44-13-fillHeight)];
    [maskPath addLineToPoint:CGPointMake(0, 44-13-fillHeight)];
    [maskPath addLineToPoint:CGPointMake(0, 44-13)];
    [maskPath closePath];
    maskLayer.path =[maskPath CGPath];
    maskLayer.fillColor=[UIColor redColor].CGColor;
    //[viewImgFillHeart.layer addSublayer:maskLayer];
    [viewImgFillHeart.layer setMask:maskLayer];
}

-(void) setReviewCount:(int)count{
    if(count==0){
        [viewImgFillHeart setHidden:YES];
    }
    [lblCountOfReview setText:[NSString stringWithFormat:@"%d",count]];
}
@end
