//
//  ReviewHeart.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/27.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "SingleHeart.h"

@interface ReviewHeart : ViewProtoType
@property SingleHeart *heart1;
@property SingleHeart *heart2;
@property SingleHeart *heart3;
@property SingleHeart *heart4;
@property SingleHeart *heart5;
@property NSArray *arrHeart;
@property double rating;
-(void) setRate:(double) rate;

@end
