//
//  ViewControllerRoot.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/10.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerTop.h"
#import "ScrollViewControllerCate.h"
#import "ViewControllerFun.h"
#import "ScrollViewControllerList.h"
#import "FXBlurView.h"
#import "GV.h"


@interface ViewControllerRoot : UIViewController
@property ViewControllerTop *viewControllerTop;
@property ScrollViewControllerCate  *scrollViewControllerCate;
@property ViewControllerFun *viewControllerFun;
@property ScrollViewControllerList *scrollViewControllerList;
@property GV *gv;
@property UIImageView *viewBG;
-(void) customTouchesEnded:(UIViewController *)controller;

@end
