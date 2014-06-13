//
//  ScrollViewCate.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewProtoType.h"
#import "ButtonRemoveCate.h"
@interface ScrollViewCate : ScrollViewProtoType<UIScrollViewDelegate>
@property double originalHeight;
@property ButtonRemoveCate *btnRemoveCate;
@end
