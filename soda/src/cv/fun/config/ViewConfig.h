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
#import "SwitchProfile.h"
#import "ButtonLogout.h"
#import "ScrollViewProtoType.h"

@interface ViewConfig : ViewExpandedPanel <UIPickerViewDataSource,UIPickerViewDelegate>
@property LabelForChangeUILang *lblLang;
@property UIPickerView *pickLang;
@property ButtonReset *btnRest;
@property NSTimer *timerChangLang;
@property LabelForChangeUILang *lblShareFavoriteToSocial;
@property LabelForChangeUILang *lblShareGoodToSocial;
@property LabelForChangeUILang *lblShareIconToSocial;
@property LabelForChangeUILang *lblOperatingTip;
@property LabelForChangeUILang *lblNotificationForDiscover;
@property SwitchProfile *switchShareFavoriteToSocial;
@property SwitchProfile *switchShareGoodToSocial;
@property SwitchProfile *switchShareIconToSocial;
@property SwitchProfile *switchOperatingTip;
@property SwitchProfile *switchNotificationForDiscover;
@property ButtonLogout *btnLogout;
@property GV *gv;
@property ScrollViewProtoType *scrollView;
@end
