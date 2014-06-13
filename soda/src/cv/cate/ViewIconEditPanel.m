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
        
        //test
        GV *gv=[GV sharedInstance];
        NSString *strTitle=[DB getUI:@"edit_title"];
        NSString *strKeyWord=[DB getUI:@"edit_keyword"];
        CGSize sizeTitle=[strTitle sizeWithAttributes: @{NSFontAttributeName:gv.titleFont}];
        CGSize sizeKeyword=[strKeyWord sizeWithAttributes: @{NSFontAttributeName:gv.titleFont}];
        double minW=sizeTitle.width;
        if(sizeTitle.width<sizeKeyword.width){
            minW=sizeKeyword.width;
        }
        double widthTotal=10+minW+10+8+200;
        viewEditTitle=[[ViewEditTitle alloc]initWithFrame:CGRectMake((gv.screenW-widthTotal)/2, 32, widthTotal, 28) minWidth:minW title:strTitle];
        [self addSubview:viewEditTitle];
        viewEditKeyword=[[ViewEditTitle alloc]initWithFrame:CGRectMake((gv.screenW-widthTotal)/2, 75, widthTotal, 28) minWidth:minW title:strKeyWord];
        [self addSubview:viewEditKeyword];
        
        //icon scroll view
        scrollViewIcon=[[ScrollViewIcon alloc] init];
        [self addSubview:scrollViewIcon];
    }
    return self;
}


@end
