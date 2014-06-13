//
//  ScrollViewProfile.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ButtonLogout.h"
#import "SwitchProfile.h"

@interface ViewProfile : ViewExpandedPanel
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
@end
