//
//  ViewPanelForFilter.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonCate.h"
#import "LabelForChangeUILang.h"

@interface ViewPanelForFilter : ViewProtoType
@property UIImageView *iconPhone;
@property LabelForChangeUILang *lblDescForPhone;
@property UISwitch *switchForPhone;

@property UIImageView *iconOpening;
@property LabelForChangeUILang *lblDescForOpening;
@property UISwitch *switchForOpening;

@property UIImageView *iconFavorite;
@property LabelForChangeUILang *lblDescForFavorite;
@property UISwitch *switchForFavorite;

@property UIImageView *iconHeart;
@property LabelForChangeUILang *lblDescForHeart;
@property UISlider *sliderForHeart;

@property UIImageView *iconOfficialSuggest;
@property LabelForChangeUILang *lblDescForOfficialSuggest;
@property UISwitch *switchForOfficialSuggest;

-(void)initialFilterSetting:(ButtonCate *)selected;
@end
