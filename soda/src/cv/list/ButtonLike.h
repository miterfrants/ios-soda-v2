//
//  ButtonLike.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ButtonLike : ButtonProtoType
@property UIImageView *imgViewFill;
-(void) checkDB;
-(BOOL) isFavorite;
@end
