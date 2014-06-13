//
//  ButtonRoundedCorner.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMenu.h"

@interface ButtonRoundedCorner : ButtonMenu
@property UILabel *lblTitle;
@property CGRect originFrame;
- (id)initWithFrame:(CGRect)frame buttonTitle:(NSString*) buttonTitle;
@end
