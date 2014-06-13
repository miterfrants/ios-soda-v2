//
//  ButtonForPersonal.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonMenu.h"

@interface ButtonForPersonal : ButtonMenu
@property BOOL isDisable;
-(void) changeToUnlogin;
-(void) changeToLogin;
- (id)initWithFrame:(CGRect)frame name:(NSString *) pName;
@end
