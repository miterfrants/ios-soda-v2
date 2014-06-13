//
//  ButtonReview.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonExpand.h"

@interface ButtonReview : ButtonExpand
@property UIImageView *viewImgFillHeart;
@property UILabel *lblCountOfReview;
-(void) setReviewCount:(int)count;
-(void) setRate:(float) rate;
@end
