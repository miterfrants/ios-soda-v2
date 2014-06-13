//
//  ScrollViewList.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewProtoType.h"
@interface ScrollViewList : ScrollViewProtoType <UIScrollViewDelegate>
@property BOOL isAutoAnimation;
-(void)iniMarker;
@end
