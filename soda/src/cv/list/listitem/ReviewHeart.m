//
//  ReviewHeart.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/27.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ReviewHeart.h"

@implementation ReviewHeart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
        self.heart1=[[SingleHeart alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        [self addSubview:self.heart1];
        self.heart2=[[SingleHeart alloc] initWithFrame:CGRectMake(18, 0, 22, 22)];
        [self addSubview:self.heart2];
        self.heart3=[[SingleHeart alloc] initWithFrame:CGRectMake(36, 0, 22, 22)];
        [self addSubview:self.heart3];
        self.heart4=[[SingleHeart alloc] initWithFrame:CGRectMake(54, 0, 22, 22)];
        [self addSubview:self.heart4];
        self.heart5=[[SingleHeart alloc] initWithFrame:CGRectMake(72, 0, 22, 22)];
        [self addSubview:self.heart5];
        
        self.arrHeart=[[NSArray alloc]initWithObjects:self.heart1, self.heart2,self.heart3, self.heart4,self.heart5, nil];
    }
    return self;
}

//0~5
-(void) setRate:(double) rate{
    self.rating=rate;
    int intger =floor(rate);
    for(int i=0;i<intger;i++){
        SingleHeart *target =(SingleHeart*)[self.arrHeart objectAtIndex:i];
        [target setRate:1.0f];
    }
    if (intger==5){
        return;
    }
    SingleHeart *endFillTarget =(SingleHeart*)[self.arrHeart objectAtIndex:intger];
    [endFillTarget setRate:(rate)-floor(rate)];
    
    for(int i=4;i>intger;i--){
        SingleHeart *target =(SingleHeart*)[self.arrHeart objectAtIndex:i];
        [target setRate:0.0f];
    }
}
@end
