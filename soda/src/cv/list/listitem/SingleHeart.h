//
//  SingleHeart.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/27.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"

@interface SingleHeart : ViewProtoType
@property UIImageView *viewBg;
@property UIImageView *viewImgFillHeart;
@property double transformRate;
-(void) setRate:(float) rate;

@end
