//
//  ButtonFunction.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"

@interface ButtonFunction : ButtonProtoType
@property UILabel *lblTitle;
@property UIImageView *viewArr;
@property BOOL isSelected;
@property NSString *name;
-(id)initWithFrameAndName:(CGRect) frame title:(NSString *) title;
-(void)toUnHighLightStatus;
@end
