//
//  ButtonInputForComment.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/29.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonProtoType.h"
#import "LabelForComment.h"
@interface ButtonInputForComment : ButtonProtoType
@property LabelForComment *lblShow;
@property UILabel *lblDefault;
@property NSString *text;
-(id)initWithFrameAndText:(CGRect) frame text:(NSString*) text;
@end
