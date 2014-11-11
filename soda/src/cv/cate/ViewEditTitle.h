//
//  ViewLeftOfTextFieldEditionTitle.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonProtoType.h"
#import "LabelForChangeUILang.h"

@interface ViewEditTitle : ButtonProtoType
@property LabelForChangeUILang *lblDisplayTitle;
@property UITextField *txtContent;
@property UIView *bg;
- (id)initWithFrameAndKey:(CGRect)frame titleKey:(NSString*) titleKey;
-(void)repose:(double)labelWidth;
@end
