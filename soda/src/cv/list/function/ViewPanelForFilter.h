//
//  ViewPanelForFilter.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonCate.h"
@interface ViewPanelForFilter : ViewProtoType
@property UIImageView *iconPhone;
@property UILabel *lblDescForPhone;
@property UISwitch *switchForPhone;

@property UIImageView *iconOpening;
@property UILabel *lblDescForOpening;
@property UISwitch *switchForOpening;

@property UIImageView *iconFavorite;
@property UILabel *lblDescForFavorite;
@property UISwitch *switchForFavorite;

@property UIImageView *iconHeart;
@property UILabel *lblDescForHeart;
@property UISlider *sliderForHeart;

@property UIImageView *iconOfficialSuggest;
@property UILabel *lblDescForOfficialSuggest;
@property UISwitch *switchForOfficialSuggest;

-(void)initialFilterSetting:(ButtonCate *)selected;
@end
