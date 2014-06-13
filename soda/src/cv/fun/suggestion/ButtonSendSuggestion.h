//
//  ButtonSendSuggestion.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/25.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonRoundedCorner.h"

@interface ButtonSendSuggestion : ButtonRoundedCorner
@property BOOL isSending;
-(void) changeToSendingStatus;
-(void) changeToCommonStatus;
-(void)changeToFinishStatus;
@end
