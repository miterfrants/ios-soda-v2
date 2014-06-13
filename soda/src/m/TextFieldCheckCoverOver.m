//
//  TextFieldCheckCoverOver.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/30.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "TextFieldCheckCoverOver.h"
#import "KeyboardTopInput.h"
@implementation TextFieldCheckCoverOver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
    }
    return self;
}
-(void)startObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

-(void)stopObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)note{
    KeyboardTopInput *keyboardTopInput= (KeyboardTopInput *)self.gv.keyboardTopInput;
    [keyboardTopInput checkAndShowKeyboard:note target:self defaultText:self.text];
}

- (void)keyboardWillHide:(NSNotification*)note
{
}

@end
