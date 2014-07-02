//
//  ScrollViewSuggestion.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/24.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ButtonSendSuggestion.h"
#import "TextComment.h"
#import "LoadingCircle.h"
#import "ScrollViewProtoType.h"
#import "ButtonMail.h"

@interface ViewSuggestion :ViewExpandedPanel

@property UILabel *lblAboutUs;
@property LoadingCircle *loading;
@property ScrollViewProtoType *scrollView;
@property ButtonMail *btnMail;
-(void)getAboutUs;
@end
