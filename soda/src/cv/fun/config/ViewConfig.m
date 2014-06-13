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
@synthesize lblTitle,lblLang,pickLang,gv,btnRest,timerChangLang;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gv =[GV sharedInstance];
        self.name=@"config";
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"config"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(85, 30, 200, 40)];
        [self addSubview:lblTitle];
        // Initialization code
        lblLang =[[UILabel alloc]initWithFrame:CGRectMake(15,87.5,101,40)];
        [lblLang setTextColor:[UIColor whiteColor]];
        [lblLang setFont:gv.fontSettingTitle];
        [lblLang setLineBreakMode:NSLineBreakByWordWrapping];
        [lblLang setMultipleTouchEnabled:YES];
        [lblLang setNumberOfLines:3];
        [lblLang setText:[DB getUI:@"lang"]];
        [self addSubview:lblLang];
        
        pickLang =[[UIPickerView alloc] initWithFrame:CGRectMake(
                                                                 lblLang.frame.origin.x+80,
                                                                 lblLang.frame.origin.y-60, 100, 31)];
        pickLang.dataSource=self;
        pickLang.delegate=self;
        [pickLang setTintColor:[Util colorWithHexString:@"#FFFFFFFF"]];
        [self addSubview:pickLang];
        
        double padding=22;
        btnRest = [[ButtonReset alloc]initWithFrame:CGRectMake(15, lblLang.frame.origin.y+lblLang.frame.size.height+padding+10, 130, 31) buttonTitle:[DB getUI:@"reset" ]];
        [self addSubview:btnRest];
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
