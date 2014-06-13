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

@interface ViewSuggestion :ViewExpandedPanel
@property TextComment *txtComment;
@property ButtonSendSuggestion *btnSend;
-(void) changeToSendingStatus;
-(void) changeToCommonStatus;
-(void) changeToFinish;
@end
