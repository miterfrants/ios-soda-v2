//
//  ViewPanelForFilter.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewPanelForFilter.h"
#import "Util.h"
#import "ScrollViewControllerCate.h"
#import "DB.h"
@implementation ViewPanelForFilter
@synthesize iconFavorite,iconHeart,iconOfficialSuggest,iconOpening,iconPhone,lblDescForFavorite,lblDescForHeart,lblDescForOfficialSuggest,lblDescForOpening,lblDescForPhone,switchForFavorite,sliderForHeart,switchForOfficialSuggest,switchForOpening,switchForPhone;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        iconPhone=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
        [iconPhone setFrame:CGRectMake(12, 20, 44, 44)];
        [self addSubview:iconPhone];
        lblDescForPhone =[[UILabel alloc] initWithFrame:CGRectMake(iconPhone.frame.origin.x+iconPhone.frame.size.width+5,
                                                                  iconPhone.frame.origin.y,
                                                                  165,
                                                                   40)];
        lblDescForPhone.lineBreakMode=NSLineBreakByCharWrapping;
        lblDescForPhone.numberOfLines=2;
        lblDescForPhone.text=@"Show only where there is a phone number.";
        [lblDescForPhone setFont:self.gv.fontListFunctionTitle];
        [lblDescForPhone setTextColor:[UIColor whiteColor]];
        [self addSubview:lblDescForPhone];
        
        switchForPhone=[[UISwitch alloc]init];
        [switchForPhone setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        [switchForPhone setFrame:CGRectMake(lblDescForPhone.frame.origin.x+lblDescForPhone.frame.size.width+14,
                                           lblDescForPhone.frame.origin.y+5,
                                            88, 48)];
        [self addSubview:switchForPhone];
        [switchForPhone addTarget:self
                           action:@selector(saveFilterConfig:)
                 forControlEvents:(UIControlEventValueChanged)];
        

        iconOpening=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light.png"]];
        [iconOpening setFrame:CGRectMake(12, 79, 44, 44)];
        [self addSubview:iconOpening];
        lblDescForOpening =[[UILabel alloc] initWithFrame:CGRectMake(iconOpening.frame.origin.x+iconOpening.frame.size.width+5,
                                                                   iconOpening.frame.origin.y,
                                                                   165,
                                                                   40)];
        lblDescForOpening.lineBreakMode=NSLineBreakByCharWrapping;
        lblDescForOpening.numberOfLines=2;
        lblDescForOpening.text=@"Show only where there is opening now.";
        [lblDescForOpening setFont:self.gv.fontListFunctionTitle];
        [lblDescForOpening setTextColor:[UIColor whiteColor]];
        [self addSubview:lblDescForOpening];
        
        switchForOpening=[[UISwitch alloc]init];
        [switchForOpening setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        [switchForOpening setFrame:CGRectMake(lblDescForOpening.frame.origin.x+lblDescForOpening.frame.size.width+14,
                                            lblDescForOpening.frame.origin.y+5,
                                            88, 48)];
        [self addSubview:switchForOpening];
        [switchForOpening addTarget:self
                           action:@selector(saveFilterConfig:)
                 forControlEvents:(UIControlEventValueChanged)];
        
        
        iconFavorite=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
        [iconFavorite setFrame:CGRectMake(12, 148, 44, 44)];
        [self addSubview:iconFavorite];
        lblDescForFavorite =[[UILabel alloc] initWithFrame:CGRectMake(iconFavorite.frame.origin.x+iconFavorite.frame.size.width+5,
                                                                     iconFavorite.frame.origin.y,
                                                                     165,
                                                                     40)];
        lblDescForFavorite.lineBreakMode=NSLineBreakByCharWrapping;
        lblDescForFavorite.numberOfLines=2;
        lblDescForFavorite.text=@"Show only where there is in your favorite.";
        [lblDescForFavorite setFont:self.gv.fontListFunctionTitle];
        [lblDescForFavorite setTextColor:[UIColor whiteColor]];
        [self addSubview:lblDescForFavorite];
        
        switchForFavorite=[[UISwitch alloc]init];
        [switchForFavorite setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        [switchForFavorite setFrame:CGRectMake(lblDescForFavorite.frame.origin.x+lblDescForFavorite.frame.size.width+14,
                                              lblDescForFavorite.frame.origin.y+5,
                                              88, 48)];
        [self addSubview:switchForFavorite];
        [switchForFavorite addTarget:self
                             action:@selector(saveFilterConfig:)
                   forControlEvents:(UIControlEventValueChanged)];
        
        
        iconHeart=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
        [iconHeart setFrame:CGRectMake(12, 217, 44, 44)];
        [self addSubview:iconHeart];
        lblDescForHeart =[[UILabel alloc] initWithFrame:CGRectMake(iconHeart.frame.origin.x+iconHeart.frame.size.width+5,
                                                                      iconHeart.frame.origin.y,
                                                                      165,
                                                                      20)];
        lblDescForHeart.numberOfLines=1;
        lblDescForHeart.text=@"Rating better than: 0";
        [lblDescForHeart setFont:self.gv.fontListFunctionTitle];
        [lblDescForHeart setTextColor:[UIColor whiteColor]];
        [self addSubview:lblDescForHeart];
        
        sliderForHeart=[[UISlider alloc]init];
        [sliderForHeart setMaximumTrackTintColor:[UIColor whiteColor]];
        [sliderForHeart setMinimumTrackTintColor:[Util colorWithHexString:@"#419291FF"]];
        [sliderForHeart setFrame:CGRectMake(lblDescForHeart.frame.origin.x-2,
                                               lblDescForHeart.frame.origin.y+28,
                                               230, 20)];
        [self addSubview:sliderForHeart];
        [sliderForHeart setMinimumValue:0];
        [sliderForHeart setMaximumValue:5];
        [sliderForHeart addTarget:self
                       action:@selector(sliderChange:)
             forControlEvents:(UIControlEventValueChanged)];
        
        
        iconOfficialSuggest=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"official_flag.png"]];
        [iconOfficialSuggest setFrame:CGRectMake(12, 286, 44, 44)];
        [self addSubview:iconOfficialSuggest];
        lblDescForOfficialSuggest =[[UILabel alloc] initWithFrame:CGRectMake(iconOfficialSuggest.frame.origin.x+iconOfficialSuggest.frame.size.width+5,
                                                                      iconOfficialSuggest.frame.origin.y,
                                                                      165,
                                                                      40)];
        lblDescForOfficialSuggest.lineBreakMode=NSLineBreakByCharWrapping;
        lblDescForOfficialSuggest.numberOfLines=2;
        lblDescForOfficialSuggest.text=@"Show only where there is official suggest.";
        [lblDescForOfficialSuggest setFont:self.gv.fontListFunctionTitle];
        [lblDescForOfficialSuggest setTextColor:[UIColor whiteColor]];
        [self addSubview:lblDescForOfficialSuggest];
        
        switchForOfficialSuggest=[[UISwitch alloc]init];
        [switchForOfficialSuggest setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        [switchForOfficialSuggest setFrame:CGRectMake(lblDescForOfficialSuggest.frame.origin.x+lblDescForOfficialSuggest.frame.size.width+14,
                                               lblDescForOfficialSuggest.frame.origin.y+5,
                                               88, 48)];
        [self addSubview:switchForOfficialSuggest];
        [switchForOfficialSuggest addTarget:self
                              action:@selector(saveFilterConfig:)
                    forControlEvents:(UIControlEventValueChanged)];
    }
    return self;
}
- (void)sliderChange:(NSNotification *)notification{
    lblDescForHeart.text=[NSString stringWithFormat:@"Rating better than: %.1f", sliderForHeart.value];
    [self saveFilterConfig:notification];
}
-(void)initialFilterSetting:(ButtonCate *)selected{
    [switchForFavorite setOn:selected.isOnlyShowFavorite ];
    [switchForOfficialSuggest setOn:selected.isOnlyShowOfficialSuggest ];
    [switchForOpening setOn:selected.isOnlyShowOpening];
    [switchForPhone setOn:selected.isOnlyShowPhone];
    [sliderForHeart setValue:selected.rating];
    lblDescForHeart.text=[NSString stringWithFormat:@"Rating better than: %.1f", sliderForHeart.value];
}

-(void)saveFilterConfig:(NSNotification *)notification{
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected=scrollViewControllerCate.selectedButtonCate;
    selected.isOnlyShowFavorite=[switchForFavorite isOn];
    selected.isOnlyShowPhone=[switchForPhone isOn];
    selected.isOnlyShowOfficialSuggest=[switchForOfficialSuggest isOn];
    selected.isOnlyShowOpening=[switchForOpening isOn];
    selected.rating=floor(sliderForHeart.value*10+0.5)/10;
    NSMutableDictionary *dicParameter=[[NSMutableDictionary alloc] init];
    if(selected.isOnlyShowFavorite){
        [dicParameter setValue:@"1" forKey:@"is_only_favorite"];
    }else{
        [dicParameter setValue:@"0" forKey:@"is_only_favorite"];
    }
    if(selected.isOnlyShowOpening){
        [dicParameter setValue:@"1" forKey:@"is_only_opening"];
    }else{
        [dicParameter setValue:@"0" forKey:@"is_only_opening"];
    }
    if(selected.isOnlyShowOfficialSuggest){
        [dicParameter setValue:@"1" forKey:@"is_only_official_suggest"];
    }else{
        [dicParameter setValue:@"0" forKey:@"is_only_official_suggest"];
    }
    if(selected.isOnlyShowPhone){
        [dicParameter setValue:@"1" forKey:@"is_only_phone"];
    }else{
        [dicParameter setValue:@"0" forKey:@"is_only_phone"];
    }
    
    [dicParameter setValue:[NSString stringWithFormat:@"%.1f",selected.rating] forKey:@"rating"];
    [dicParameter setValue:[NSString stringWithFormat:@"%d",selected.iden] forKey:@"id"];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_saveFilterConfig:) object:dicParameter];
    [self.gv.FMDatabaseQueue addOperation:operation];
}

-(void)_saveFilterConfig:(NSDictionary *)dicParameter{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection set is_only_phone=%d,is_only_favorite=%d, is_only_official_suggest=%d,is_only_opening=%d,rating=%.1f WHERE id=%d",
                       [[dicParameter valueForKey:@"is_only_phone"] intValue],
                       [[dicParameter valueForKey:@"is_only_favorite"] intValue],
                       [[dicParameter valueForKey:@"is_only_official_suggest"] intValue],
                       [[dicParameter valueForKey:@"is_only_opening"] intValue],
                       [[dicParameter valueForKey:@"rating"] doubleValue],
                       [[dicParameter valueForKey:@"id"] intValue]]];
    [db close];
}

@end
