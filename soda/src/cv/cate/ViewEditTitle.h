//
//  ViewLeftOfTextFieldEditionTitle.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonProtoType.h"

@interface ViewEditTitle : ButtonProtoType
@property UILabel *lblDisplayTitle;
@property UITextField *txtContent;
- (id)initWithFrame:(CGRect)frame minWidth:(double) minWidth title:(NSString*) title;
@end
