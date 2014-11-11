//
//  LabelForChangeUILang.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/7/8.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GV.h"

@interface LabelForChangeUILang : UILabel
@property (nonatomic, retain) NSString *key;
@property GV *gv;
@property SEL completeInvoke;
@property UIView *parentView;
-(void)changeLang;
@end
