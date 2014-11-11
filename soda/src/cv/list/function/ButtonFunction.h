//
//  ButtonFunction.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"
#import "LabelForChangeUILang.h"

@interface ButtonFunction : ButtonProtoType
@property LabelForChangeUILang *lblTitle;
@property UIImageView *viewArr;
@property BOOL isSelected;
@property NSString *name;
-(id)initWithFrameAndName:(CGRect) frame titleKey:(NSString *) titleKey;
-(void)toUnHighLightStatus;
-(void)toHighLightStatus;
@end
