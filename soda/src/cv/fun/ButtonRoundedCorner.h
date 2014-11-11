//
//  ButtonRoundedCorner.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMenu.h"
#import "LabelForChangeUILang.h"
@interface ButtonRoundedCorner : ButtonMenu
@property LabelForChangeUILang *lblTitle;
@property CGRect originFrame;
- (id)initWithFrame:(CGRect)frame buttonTitleKey:(NSString*) buttonTitleKey;
@end
