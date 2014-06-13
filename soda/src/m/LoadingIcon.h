//
//  LoadingIcon.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingIcon : UIView;
@property UIImageView *imgViewIcon;
@property NSTimer *animationTimer;
@property UILabel *lblLoadingInfo;
@property BOOL isHiding;
@property BOOL isStop;
-(void)start;
-(void)stop;
-(void)hide;
@end
