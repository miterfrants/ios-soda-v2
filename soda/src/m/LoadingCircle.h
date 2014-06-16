//
//  LoadingCircle.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingCircle : UIView
@property NSTimer *animationTimer;
@property BOOL isHiding;
-(void)start;
-(void)stop;
-(void)hide;
@end
