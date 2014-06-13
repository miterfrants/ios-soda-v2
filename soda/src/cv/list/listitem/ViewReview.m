//
//  ViewReview.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/26.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewReview.h"
#import "DB.h"
#import "ListItem.h"
#import "Util.h"
@implementation ViewReview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithParameter:(CGRect)frame name:(NSString *) name rating:(float)rating comment:(NSString*) comment announceDate:(NSString *) announceDate{
    self = [super initWithFrame:frame];
    if (self) {
        //name
        self.lblName=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.gv.screenW-80, 999999)];
        [self.lblName setTextColor:[UIColor whiteColor]];
        [self.lblName setFont:self.gv.fontListFunctionTitle];
        [self.lblName setText:[NSString stringWithFormat:@"%@:",name]];
        self.lblName.lineBreakMode=NSLineBreakByCharWrapping;
       CGSize expectedSizeForName = [self.lblName sizeThatFits:CGSizeMake(self.gv.screenW-40, 99999)];
        [self.lblName setFrame:CGRectMake(20,0, expectedSizeForName.width,expectedSizeForName.height)];

        //announce
        self.lblAnnounceDate=[[UILabel alloc] initWithFrame:CGRectMake(20, 18, 80, 20)];
        [self.lblAnnounceDate setTextColor:[UIColor whiteColor]];
        [self.lblAnnounceDate setFont:self.gv.fontListAnnounceDate];
        [self.lblAnnounceDate setText:announceDate];
        self.lblAnnounceDate.lineBreakMode=NSLineBreakByCharWrapping;
        [self addSubview:self.lblAnnounceDate];
        
        //comment
        self.lblComment=[[UILabel alloc] initWithFrame:CGRectMake(20, 50, self.gv.screenW-40, 99999)];
        [self.lblComment setTextColor:[UIColor whiteColor]];
        [self.lblComment setFont:self.gv.fontListFunctionTitle];
        [self.lblComment setText:comment];
        self.lblComment.lineBreakMode=NSLineBreakByCharWrapping;
        self.lblComment.numberOfLines=200;
       CGSize expectedSizeForComment = [self.lblComment sizeThatFits:CGSizeMake(self.gv.screenW-40, 99999)];
        [self.lblComment setFrame:CGRectMake(20,50, expectedSizeForComment.width,expectedSizeForComment.height)];
        
        //review heart
        self.reviewHeart=[[ReviewHeart alloc] initWithFrame:CGRectMake(20+80, 18, 100, 20)];
        [self.reviewHeart setRate:rating];
        
        [self addSubview:self.lblName];
        [self addSubview:self.lblComment];
        [self addSubview:self.reviewHeart];
        
        [self setFrame:CGRectMake(0, self.frame.origin.y, self.gv.screenW-40, expectedSizeForComment.height+expectedSizeForName.height+50)];

        //bottom border
        self.viewBottomBorder=[[UIView alloc] initWithFrame:CGRectMake(15, expectedSizeForComment.height+expectedSizeForName.height+50, self.gv.screenW-30, 1)];
        [self.viewBottomBorder setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7C"]];
        [self addSubview:self.viewBottomBorder];
    }
    return self;
}


@end
