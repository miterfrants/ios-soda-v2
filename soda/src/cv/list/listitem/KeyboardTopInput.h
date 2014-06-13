//
//  KeyboardTopInput.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/29.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewProtoType.h"
#import "ButtonKeyboardTopDone.h"

@interface KeyboardTopInput : ViewProtoType <UITextViewDelegate>
@property UITextView *txtInput;
@property CGRect originFrame;
@property id target;
@property ButtonKeyboardTopDone *btnDone;
//for review comment
-(void)showKeyboardWithText:(NSString *)text target:(id)target;
//for location only iphone 4/iphone 4s small screen;
-(void)checkAndShowKeyboard:(NSNotification *)note  target:(id)target defaultText:(NSString *) defaultText;
-(void)fourceShowWithTarget:(id) target defaultText:(NSString*)defaultText;
-(void)hideKeyboard:(id)sender;

@end
