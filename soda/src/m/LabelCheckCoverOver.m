//
//  LabelCheckCoverOver.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/31.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "LabelCheckCoverOver.h"
#import "KeyboardTopInput.h"
@implementation LabelCheckCoverOver

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv=[GV sharedInstance];
    }
    return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    KeyboardTopInput *keyboardTopInput= (KeyboardTopInput *)self.gv.keyboardTopInput;
    [keyboardTopInput fourceShowWithTarget:self defaultText:self.text];
    [super touchesEnded:touches withEvent:event];
}
@end
