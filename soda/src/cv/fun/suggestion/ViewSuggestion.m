//
//  ScrollViewSuggestion.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/24.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewSuggestion.h"
#import "Util.h"
#import "DB.h"
#import "GV.h"
@implementation ViewSuggestion
@synthesize lblTitle,txtComment,btnSend;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"suggestion";
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"suggestion"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(85, 30, 200, 40)];
        [self addSubview:lblTitle];
        double commentHeight=200;
        if([GV sharedInstance].screenH>568){
            commentHeight=170;
        }
        txtComment=[[TextComment alloc]initWithFrame:CGRectMake(15, 87.5, 172, commentHeight)];
        [txtComment setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7F"]];
        [self addSubview:txtComment];
        [txtComment setFont:[GV sharedInstance].contentFont];
        [txtComment setTextColor:[Util colorWithHexString:@"#419291FF"]];
        [txtComment setTintColor:[Util colorWithHexString:@"#263439FF"]];
        btnSend=[[ButtonSendSuggestion alloc]initWithFrame:CGRectMake(15,87.5+200+20,130, 30) buttonTitle:[DB getUI:@"send"]];
        [self addSubview:btnSend];
    }
    return self;
}
-(void) changeToSendingStatus{
    [txtComment setEditable:NO];
    [txtComment resignFirstResponder];
    [txtComment setBackgroundColor:[Util colorWithHexString:@"#419291FF"]];
    [txtComment setTextColor:[UIColor whiteColor]];
    [btnSend changeToSendingStatus];
}
-(void) changeToCommonStatus{
    [txtComment setEditable:YES];
    [txtComment setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7F"]];
    [txtComment setTextColor:[Util colorWithHexString:@"#419291FF"]];
    [btnSend changeToCommonStatus];
}

-(void) changeToFinish{
    [btnSend changeToFinishStatus];
    [btnSend.highlightTimer invalidate];
    btnSend.highlightTimer=nil;
    btnSend.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:1.3 target:self selector:@selector(changeToCommonStatus) userInfo:nil repeats:NO];
}


@end
