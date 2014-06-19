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
@property UILabel *lblLang;
@property UIPickerView *pickLang;
@property ButtonReset *btnRest;
@property NSTimer *timerChangLang;
@property UILabel *lblTitle;
@property UILabel *lblShareFavoriteToSocial;
@property UILabel *lblShareGoodToSocial;
@property UILabel *lblShareIconToSocial;
@property UILabel *lblOperatingTip;
@property UILabel *lblNotificationForDiscover;
@property SwitchProfile *switchShareFavoriteToSocial;
@property SwitchProfile *switchShareGoodToSocial;
@property SwitchProfile *switchShareIconToSocial;
@property SwitchProfile *switchOperatingTip;
@property SwitchProfile *switchNotificationForDiscover;
@property ButtonLogout *btnLogout;
@property GV *gv;
@property ScrollViewProtoType *scrollView;
@end
