//
//  ScrollViewProfile.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/22.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProfile.h"
#import "GV.h"
#import "Util.h"
#import "ButtonLogout.h"
#import "DB.h"
@implementation ViewProfile
@synthesize btnLogout,lblShareFavoriteToSocial,lblShareGoodToSocial,
lblShareIconToSocial,lblOperatingTip,
switchShareFavoriteToSocial,
switchShareGoodToSocial,
switchOperatingTip,lblNotificationForDiscover,
switchNotificationForDiscover,
switchShareIconToSocial,lblTitle;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"profile";
        GV *gv=[GV sharedInstance];
        
        double padding=22;
        
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"profile"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(85, 30, 200, 40)];
        [self addSubview:lblTitle];
        
        
        lblShareFavoriteToSocial = [[UILabel alloc]initWithFrame:CGRectMake(15,87.5,101,40)];
        [lblShareFavoriteToSocial setTextColor:[UIColor whiteColor]];
        [lblShareFavoriteToSocial setFont:gv.fontSettingTitle];
        [lblShareFavoriteToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareFavoriteToSocial setMultipleTouchEnabled:YES];
        [lblShareFavoriteToSocial setNumberOfLines:3];
        //[lblShareFavoriteToSocial setBackgroundColor:[UIColor redColor]];
        [self addSubview:lblShareFavoriteToSocial];
        
        switchShareFavoriteToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                        lblShareFavoriteToSocial.frame.origin.x+115.5,
                                                                           lblShareFavoriteToSocial.frame.origin.y+7, 51, 31)];
        [switchShareFavoriteToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];

        if([[DB getSysConfig:@"share_favorite_on_social"] isEqual:@"1"]){
            [switchShareFavoriteToSocial setOn:YES];
        }
        switchShareFavoriteToSocial.name=@"share_favorite_on_social";
        [self addSubview:switchShareFavoriteToSocial];
        
        
        lblShareGoodToSocial = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                      15,lblShareFavoriteToSocial.frame.origin.y+lblShareFavoriteToSocial.frame.size.height+padding,
                                                                      101,
                                                                      40)];
        [lblShareGoodToSocial setTextColor:[UIColor whiteColor]];
        [lblShareGoodToSocial setFont:gv.fontSettingTitle];
        [lblShareGoodToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareGoodToSocial setMultipleTouchEnabled:YES];
        [lblShareGoodToSocial setNumberOfLines:3];
        [self addSubview:lblShareGoodToSocial];
        
        switchShareGoodToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                         lblShareGoodToSocial.frame.origin.x+115.5,
                                                                         lblShareGoodToSocial.frame.origin.y+7, 51, 31)];
        [switchShareGoodToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"share_good_on_social"] isEqual:@"1"]){
            [switchShareGoodToSocial setOn:YES];
        }
        switchShareGoodToSocial.name=@"share_good_on_social";
        [self addSubview:switchShareGoodToSocial];
        

        lblShareIconToSocial = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                        15,lblShareGoodToSocial.frame.origin.y+lblShareGoodToSocial.frame.size.height+padding,
                                                                        101,
                                                                        40)];
        [lblShareIconToSocial setTextColor:[UIColor whiteColor]];
        [lblShareIconToSocial setFont:gv.fontSettingTitle];
        [lblShareIconToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareIconToSocial setMultipleTouchEnabled:YES];
        [lblShareIconToSocial setNumberOfLines:3];
        [self addSubview:lblShareIconToSocial];
        
        switchShareIconToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                           lblShareIconToSocial.frame.origin.x+115.5,
                                                                           lblShareIconToSocial.frame.origin.y+7, 51, 31)];
        [switchShareIconToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"share_icon_on_social"] isEqual:@"1"]){
            [switchShareIconToSocial setOn:YES];
        }
        switchShareIconToSocial.name=@"share_icon_on_social";
        [self addSubview:switchShareIconToSocial];
        
        
        
        
        lblOperatingTip = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                        15,lblShareIconToSocial.frame.origin.y+lblShareIconToSocial.frame.size.height+padding,
                                                                        101,
                                                                        40)];
        [lblOperatingTip setTextColor:[UIColor whiteColor]];
        [lblOperatingTip setFont:gv.fontSettingTitle];
        [lblOperatingTip setLineBreakMode:NSLineBreakByWordWrapping];
        [lblOperatingTip setMultipleTouchEnabled:YES];
        [lblOperatingTip setNumberOfLines:3];
        lblOperatingTip.text= [DB getUI:@"operating_tip"];
        [self addSubview:lblOperatingTip];
        
        switchOperatingTip=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                           lblOperatingTip.frame.origin.x+115.5,
                                                                           lblOperatingTip.frame.origin.y+7, 51, 31)];
        [switchOperatingTip setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"operating_tip"] isEqual:@"1"]){
            [switchOperatingTip setOn:YES];
        }
        switchOperatingTip.name=@"operating_tip";
        [self addSubview:switchOperatingTip];

        
        lblNotificationForDiscover = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                   15,lblOperatingTip.frame.origin.y+lblOperatingTip.frame.size.height+padding,
                                                                   101,
                                                                   40)];
        [lblNotificationForDiscover setTextColor:[UIColor whiteColor]];
        [lblNotificationForDiscover setFont:gv.fontSettingTitle];
        [lblNotificationForDiscover setLineBreakMode:NSLineBreakByWordWrapping];
        [lblNotificationForDiscover setMultipleTouchEnabled:YES];
        [lblNotificationForDiscover setNumberOfLines:3];
        lblNotificationForDiscover.text= [DB getUI:@"notification_for_discover"];
        [self addSubview:lblNotificationForDiscover];
        
        switchNotificationForDiscover=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                      lblNotificationForDiscover.frame.origin.x+115.5,
                                                                      lblNotificationForDiscover.frame.origin.y+7, 51, 31)];
        [switchNotificationForDiscover setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"notification_for_discover"] isEqual:@"1"]){
            [switchNotificationForDiscover setOn:YES];
        }
        switchNotificationForDiscover.name=@"notification_for_discover";
        [self addSubview:switchNotificationForDiscover];

        
        btnLogout=[[ButtonLogout alloc]initWithFrame:CGRectMake(lblNotificationForDiscover.frame.origin.x,
                                                            lblNotificationForDiscover.frame.origin.y+lblNotificationForDiscover.frame.size.height+padding+10,
                                                            130, 30) buttonTitle:[DB getUI:@"logout" ]];

        [self addSubview:btnLogout];

        
    }
    return self;
}
@end
