//
//  TextViewCheckCoverOver.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/31.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "TextViewCheckCoverOver.h"
#import "KeyboardTopInput.h"
@implementation TextViewCheckCoverOver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    return self;
}


-(void)keyboardWillShow:(NSNotification *)note{
    KeyboardTopInput *keyboardTopInput= (KeyboardTopInput *)self.gv.keyboardTopInput;
    [keyboardTopInput checkAndShowKeyboard:note target:self defaultText:self.text];
}

- (void)keyboardWillHide:(NSNotification*)note
{
}

@end
