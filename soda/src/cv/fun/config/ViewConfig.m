//
//  ScrollViewConfig.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/5.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewConfig.h"
#import "DB.h"
#import "Util.h"
#import "AppDelegate.h"

@implementation ViewConfig
@synthesize lblTitle,lblLang,pickLang,gv,btnRest,timerChangLang,btnLogout,lblShareFavoriteToSocial,lblShareGoodToSocial,
lblShareIconToSocial,lblOperatingTip,
switchShareFavoriteToSocial,
switchShareGoodToSocial,
switchOperatingTip,lblNotificationForDiscover,
switchNotificationForDiscover,
switchShareIconToSocial;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gv =[GV sharedInstance];
        self.name=@"config";
        double padding=22;
        
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"config"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(85, 30, 200, 40)];
        [self addSubview:lblTitle];
        
        self.scrollView=[[ScrollViewProtoType alloc] initWithFrame:CGRectMake(0, 80, frame.size.width,self.gv.screenH-80)];
        [self addSubview:self.scrollView];
        
        // Initialization code
        lblLang =[[UILabel alloc]initWithFrame:CGRectMake(15,10,101,40)];
        [lblLang setTextColor:[UIColor whiteColor]];
        [lblLang setFont:gv.fontNormalForHebrew];
        [lblLang setLineBreakMode:NSLineBreakByWordWrapping];
        [lblLang setMultipleTouchEnabled:YES];
        [lblLang setNumberOfLines:3];
        [lblLang setText:[DB getUI:@"lang"]];
        [self.scrollView addSubview:lblLang];
        
        pickLang =[[UIPickerView alloc] initWithFrame:CGRectMake(
                                                                 lblLang.frame.origin.x+80,
                                                                 lblLang.frame.origin.y-60, 100, 31)];
        pickLang.dataSource=self;
        pickLang.delegate=self;
        [pickLang setTintColor:[Util colorWithHexString:@"#FFFFFFFF"]];
        [self.scrollView addSubview:pickLang];

        padding=22;
        lblShareFavoriteToSocial = [[UILabel alloc]initWithFrame:CGRectMake(15,lblLang.frame.origin.y+lblLang.frame.size.height+padding,120,40)];
        [lblShareFavoriteToSocial setTextColor:[UIColor whiteColor]];
        [lblShareFavoriteToSocial setFont:gv.fontNormalForHebrew];
        [lblShareFavoriteToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareFavoriteToSocial setMultipleTouchEnabled:YES];
        [lblShareFavoriteToSocial setNumberOfLines:3];
        [lblShareFavoriteToSocial setText:[DB getUI:@"share_favorite"]];
        [self.scrollView addSubview:lblShareFavoriteToSocial];
        
        switchShareFavoriteToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                                    lblShareFavoriteToSocial.frame.origin.x+130,
                                                                                    lblShareFavoriteToSocial.frame.origin.y+7, 51, 31)];
        //[switchShareFavoriteToSocial setEnabled:NO];
        [switchShareFavoriteToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        
        if([[DB getSysConfig:@"share_favorite"] isEqual:@"1"]){
            [switchShareFavoriteToSocial setOn:YES];
        }
        switchShareFavoriteToSocial.name=@"share_favorite";
        [self.scrollView addSubview:switchShareFavoriteToSocial];
        
        
        padding=22;
        lblShareGoodToSocial = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                        15,lblShareFavoriteToSocial.frame.origin.y+lblShareFavoriteToSocial.frame.size.height+padding,
                                                                        lblShareFavoriteToSocial.frame.size.width,
                                                                        40)];
        [lblShareGoodToSocial setTextColor:[UIColor whiteColor]];
        [lblShareGoodToSocial setFont:gv.fontNormalForHebrew];
        [lblShareGoodToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareGoodToSocial setMultipleTouchEnabled:YES];
        [lblShareGoodToSocial setNumberOfLines:3];
        [lblShareGoodToSocial setText:[DB getUI:@"share_good"]];
        [self.scrollView addSubview:lblShareGoodToSocial];
        
        switchShareGoodToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                                lblShareGoodToSocial.frame.origin.x+130,
                                                                                lblShareGoodToSocial.frame.origin.y+7, 51, 31)];
        [switchShareGoodToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"share_good"] isEqual:@"1"]){
            [switchShareGoodToSocial setOn:YES];
        }
        switchShareGoodToSocial.name=@"share_good";
        [self.scrollView addSubview:switchShareGoodToSocial];
        
        
        lblShareIconToSocial = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                        15,lblShareGoodToSocial.frame.origin.y+lblShareGoodToSocial.frame.size.height+padding,
                                                                        lblShareFavoriteToSocial.frame.size.width,
                                                                        40)];
        [lblShareIconToSocial setTextColor:[UIColor whiteColor]];
        [lblShareIconToSocial setFont:gv.fontNormalForHebrew];
        [lblShareIconToSocial setLineBreakMode:NSLineBreakByWordWrapping];
        [lblShareIconToSocial setMultipleTouchEnabled:YES];
        [lblShareIconToSocial setNumberOfLines:3];
        [lblShareIconToSocial setText:[DB getUI:@"share_icon"]];
        [self.scrollView addSubview:lblShareIconToSocial];
        
        switchShareIconToSocial=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                                lblShareIconToSocial.frame.origin.x+130,
                                                                                lblShareIconToSocial.frame.origin.y+7, 51, 31)];
        [switchShareIconToSocial setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"share_icon"] isEqual:@"1"]){
            [switchShareIconToSocial setOn:YES];
        }
        switchShareIconToSocial.name=@"share_icon";
        [self.scrollView addSubview:switchShareIconToSocial];
        
        
        
        
        lblOperatingTip = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                   15,lblShareIconToSocial.frame.origin.y+lblShareIconToSocial.frame.size.height+padding,
                                                                   lblShareFavoriteToSocial.frame.size.width,
                                                                   40)];
        [lblOperatingTip setTextColor:[UIColor whiteColor]];
        [lblOperatingTip setFont:gv.fontNormalForHebrew];
        [lblOperatingTip setLineBreakMode:NSLineBreakByWordWrapping];
        [lblOperatingTip setMultipleTouchEnabled:YES];
        [lblOperatingTip setNumberOfLines:3];
        [lblOperatingTip setText:[DB getUI:@"tip"]];
        [self.scrollView addSubview:lblOperatingTip];
        
        switchOperatingTip=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                           lblOperatingTip.frame.origin.x+130,
                                                                           lblOperatingTip.frame.origin.y+7, 51, 31)];
        [switchOperatingTip setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"tip"] isEqual:@"1"]){
            [switchOperatingTip setOn:YES];
        }
        switchOperatingTip.name=@"tip";
        [self.scrollView addSubview:switchOperatingTip];
        
        
        lblNotificationForDiscover = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                              15,lblOperatingTip.frame.origin.y+lblOperatingTip.frame.size.height+padding,
                                                                              lblShareFavoriteToSocial.frame.size.width,
                                                                              40)];
        [lblNotificationForDiscover setTextColor:[UIColor whiteColor]];
        [lblNotificationForDiscover setFont:gv.fontNormalForHebrew];
        [lblNotificationForDiscover setLineBreakMode:NSLineBreakByWordWrapping];
        [lblNotificationForDiscover setMultipleTouchEnabled:YES];
        [lblNotificationForDiscover setNumberOfLines:3];
        lblNotificationForDiscover.text= [DB getUI:@"notification"];
        [self.scrollView addSubview:lblNotificationForDiscover];
        
        switchNotificationForDiscover=[[SwitchProfile alloc] initWithFrame:CGRectMake(
                                                                                      lblNotificationForDiscover.frame.origin.x+130,
                                                                                      lblNotificationForDiscover.frame.origin.y+7, 51, 31)];
        [switchNotificationForDiscover setOnTintColor:[Util colorWithHexString:@"#419291FF"]];
        if([[DB getSysConfig:@"notification"] isEqual:@"1"]){
            [switchNotificationForDiscover setOn:YES];
        }
        switchNotificationForDiscover.name=@"notification";
        [self.scrollView addSubview:switchNotificationForDiscover];
        
        
        btnLogout=[[ButtonLogout alloc]initWithFrame:CGRectMake(lblLang.frame.origin.x,
                                                                lblNotificationForDiscover.frame.origin.y+lblNotificationForDiscover.frame.size.height+padding+10,
                                                                180, 30) buttonTitle:[DB getUI:@"logout" ]];
        
        [self.scrollView addSubview:btnLogout];

        
        btnRest = [[ButtonReset alloc]initWithFrame:CGRectMake(lblLang.frame.origin.x, btnLogout.frame.origin.y+btnLogout.frame.size.height+padding+10, 180, 31) buttonTitle:[DB getUI:@"reset" ]];
        [self.scrollView addSubview:btnRest];
        
        [self.scrollView setContentSize:CGSizeMake(frame.size.width, btnRest.frame.origin.y+btnRest.frame.size.height+padding)];
    }
    return self;
}


-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [timerChangLang invalidate];
    timerChangLang =nil;
    NSArray *keys=gv.dicLang.allKeys;
    NSString *lang=[keys objectAtIndex:[pickLang selectedRowInComponent:0]];
    if(![lang isEqual: [DB getSysConfig:@"lang"]]){
        timerChangLang=[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(showChangeLangHint:) userInfo:nil repeats:NO];
    }
}
-(void)showChangeLangHint:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Language Setting"
                          message:@"Do you want to change language?"
                          delegate:self
                          cancelButtonTitle:@"No"
                          otherButtonTitles:@"Yes",nil];
    [alert show];
}
//這個最好搬到 controller 那一層
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",alertView);
    if (buttonIndex == 1) {
        NSLog(@"YES, change language");

        NSArray *keys=gv.dicLang.allKeys;
        NSString *lang=[keys objectAtIndex:[pickLang selectedRowInComponent:0]];
        [DB changeLang:lang];
        AppDelegate *app=(AppDelegate *) [[UIApplication sharedApplication] delegate];
        [app changeUILang];
    } else {
        NSLog(@"NO");
        NSArray *keys = [gv.dicLang allKeys];
        for(int i=0;i<keys.count;i++){
            if( [[keys objectAtIndex:i] isEqualToString:[DB getSysConfig:@"lang"]]){
                [pickLang selectRow:i inComponent:0 animated:YES];
                break;
            }
        }

    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [GV sharedInstance].dicLang.count;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    retval.font = [GV sharedInstance].fontSettingPicker;
    NSArray *keys = [[GV sharedInstance].dicLang allKeys];
    retval.text = [[GV sharedInstance].dicLang objectForKey:[keys objectAtIndex:row]];
    retval.textColor=[UIColor whiteColor];
    retval.textAlignment=NSTextAlignmentCenter;
    return retval;
}
@end
