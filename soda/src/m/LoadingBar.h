//
//  LoadingBar.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingBar : UIView
@property UIView *viewBg;
@property UIView *viewProcessBar;
@property CAShapeLayer *maskLayer;
@property BOOL isHiding;
@property UIView *test;
-(void)process:(double)per completion:(void(^)()) completion;
-(void)hide;
@end
