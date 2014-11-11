//
//  ViewPanel.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewIconEditPanel.h"
#import "ViewControllerRoot.h"

#import "TextFieldEditIconTitle.h"
#import "Util.h"
#import "GV.h"
#import "DB.h"
#import "ScrollViewControllerCate.h"



@implementation ViewIconEditPanel
@synthesize viewEditTitle,viewEditKeyword,imgViewEditBg,blurView,btnSave
    ,scrollViewIcon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        blurView= [[BlurView alloc]initWithFrame:CGRectMake(0, 17, frame.size.width, frame.size.height)];


        [blurView setDynamic:NO];
        blurView.tintColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.2];
        [blurView updateAsynchronously:YES completion:nil];
        [blurView setBlurRadius:30.0f];
        [self addSubview:blurView];
        
        
        //button save local database
        //onece
        btnSave=[[ButtonSave alloc]init];
        [self addSubview:btnSave];

        CALayer *topBorder = [CALayer layer];
        topBorder.borderColor = [UIColor whiteColor].CGColor;
        topBorder.borderWidth = 1;
        topBorder.frame = CGRectMake(-1, 17, frame.size.width+2, frame.size.height+1);
        [self.layer addSublayer:topBorder];
        
        //inner will change viewEditTitle, viewEditKeyword frame;
        viewEditTitle=[[ViewEditTitle alloc]initWithFrameAndKey:CGRectMake(0, 32, self.gv.screenW, 28) titleKey:@"edit_title"];
        [self addSubview:viewEditTitle];
        viewEditKeyword=[[ViewEditTitle alloc]initWithFrameAndKey:CGRectMake(0, 75, self.gv.screenW, 28) titleKey:@"edit_keyword"];
        [self addSubview:viewEditKeyword];
        double minLabelWidth=viewEditKeyword.lblDisplayTitle.frame.size.width;
        if(viewEditKeyword.lblDisplayTitle.frame.size.width<viewEditTitle.lblDisplayTitle.frame.size.width){
            minLabelWidth=viewEditTitle.lblDisplayTitle.frame.size.width;
        }
        [viewEditTitle repose:minLabelWidth];
        [viewEditKeyword repose:minLabelWidth];
        
        viewEditTitle.lblDisplayTitle.parentView=self;
        viewEditKeyword.lblDisplayTitle.parentView=self;
        viewEditTitle.lblDisplayTitle.completeInvoke=@selector(changeUILangComplete);
        viewEditKeyword.lblDisplayTitle.completeInvoke=@selector(changeUILangComplete);
        
        //icon scroll view
        scrollViewIcon=[[ScrollViewIcon alloc] init];
        [self addSubview:scrollViewIcon];
    }
    return self;
}

-(void)changeUILangComplete{
    int padding=10;
    CGSize labelSizeForViewEditKeyword=[viewEditKeyword.lblDisplayTitle sizeThatFits:CGSizeMake(100, 28)];
    [viewEditKeyword.lblDisplayTitle setFrame:CGRectMake(padding
                                         , 0, labelSizeForViewEditKeyword.width, 28)];

    
    CGSize labelSizeForViewEditTitle=[viewEditTitle.lblDisplayTitle sizeThatFits:CGSizeMake(100, 28)];
    [viewEditTitle.lblDisplayTitle setFrame:CGRectMake(padding
                                                         , 0, labelSizeForViewEditTitle.width, 28)];
    double minLabelWidth=viewEditKeyword.lblDisplayTitle.frame.size.width;
    if(viewEditKeyword.lblDisplayTitle.frame.size.width<viewEditTitle.lblDisplayTitle.frame.size.width){
        minLabelWidth=viewEditTitle.lblDisplayTitle.frame.size.width;
    }
    [viewEditTitle repose:minLabelWidth];
    [viewEditKeyword repose:minLabelWidth];
}

@end
