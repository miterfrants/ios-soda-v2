//
//  ScrollViewConfig.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/5.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ButtonReset.h"
#import "GV.h"

@interface ViewConfig : ViewExpandedPanel <UIPickerViewDataSource,UIPickerViewDelegate>
@property UILabel *lblLang;
@property UIPickerView *pickLang;
@property ButtonReset *btnRest;
@property NSTimer *timerChangLang;
@property GV *gv;


@end
