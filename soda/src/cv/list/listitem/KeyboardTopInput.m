//
//  KeyboardTopInput.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/29.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "KeyboardTopInput.h"
#import "Util.h"
#import "ButtonComment.h"
#import "LabelCheckCoverOver.h"

@implementation KeyboardTopInput

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.txtInput=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.txtInput];
        [self.txtInput setFont:self.gv.fontListFunctionTitle];
        self.originFrame=frame;
        
        self.btnDone=[[ButtonKeyboardTopDone alloc] initWithFrame:CGRectMake(self.gv.screenW-60, 0, 60, frame.size.height)];
        [self addSubview:self.btnDone];
        [self.btnDone setBackgroundColor:[Util colorWithHexString:@"#aedbdbFF"]];
        [self.btnDone addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];

        self.txtInput.delegate=self;
    }
    return self;
}

-(void)hideKeyboard:(id)sender{
    if([self.target isKindOfClass:[LabelCheckCoverOver class]]){
        LabelCheckCoverOver *lblTarget=(LabelCheckCoverOver *)self.target;
        [GV setGlobalStatus:lblTarget.originalStatus];
    }
    [self.txtInput resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification*)note
{
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    [UIView animateWithDuration:duration delay:0.0 options:(curve<<16) animations:^{
        [self setFrame:self.originFrame];
    } completion:^(BOOL finished) {
        if(finished){
            self.txtInput.text=@"";
            self.target=nil;
        }
    }];
}

-(void)checkAndShowKeyboard:(NSNotification *)note  target:(id)target defaultText:(NSString *) defaultText {
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    UIView *UITarget=(UIView *)target;
    CGRect f = [UITarget convertRect:UITarget.bounds toView:self.gv.viewControllerRoot.view];
    if(f.origin.y+UITarget.frame.size.height> self.gv.screenH-keyboardSize.height-50){
        double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
        [self.txtInput becomeFirstResponder];
        self.target=UITarget;
        self.txtInput.text=defaultText;
        [UIView animateWithDuration:duration delay:0.0 options:(curve) animations:^
         {
             [self setFrame:CGRectMake(0, self.gv.screenH-keyboardSize.height-self.frame.size.height, self.gv.screenW, self.frame.size.height)];
         } completion:^(BOOL finished) {
             if (finished)
             {
             }
         }];
    }
}


-(void)showKeyboardWithText:(NSString *)text target:(id)pTarget{
    self.target=pTarget;
    self.txtInput.text=text;
    [self.txtInput becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView{
    if(self.target==nil){
        return;
    }else{
        UIView *this=(UIView *)self.target;
        if([this.superview.superview isKindOfClass:[ButtonComment class]]){
            ButtonComment *btnComment=(ButtonComment *)this.superview.superview;
            if(textView.text.length>0){
                btnComment.btnInput.lblDefault.text=@"";
            }else{
                btnComment.btnInput.lblDefault.text=btnComment.defaultString;
            }
        }
        if([self.target isKindOfClass:[UILabel class]]){
            ((UILabel *)self.target).text=textView.text;
        }else if([self.target isKindOfClass:[UITextField class]]){
            ((UITextField *)self.target).text=textView.text;
        }else if([self.target isKindOfClass:[UITextView class]]){
            ((UITextView *)self.target).text=textView.text;
        }

    }
}
-(void)fourceShowWithTarget:(id) target defaultText:(NSString*)defaultText{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [self.txtInput becomeFirstResponder];
    self.txtInput.text=defaultText;
    self.target=target;
}
-(void)keyboardWillShow:(NSNotification *)note{
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:duration delay:0.0 options:(curve) animations:^
     {
         [self setFrame:CGRectMake(0, self.gv.screenH-keyboardSize.height-self.frame.size.height, self.gv.screenW, self.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished)
         {
         }
     }];

}
@end
