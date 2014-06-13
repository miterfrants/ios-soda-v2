//
//  ButtonMenu.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"

@interface ButtonMenu : ButtonProtoType
@property NSString *name;
@property UIImageView *imgViewIcon;
- (id)initWithFrame:(CGRect)frame name:(NSString *) pName;
@end
