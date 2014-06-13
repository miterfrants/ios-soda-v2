//
//  TextFieldCheckCoverOver.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/30.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GV.h"
@interface TextFieldCheckCoverOver : UITextField <UITextFieldDelegate>
@property GV *gv;
-(void)stopObserver;
-(void)startObserver;
@end
