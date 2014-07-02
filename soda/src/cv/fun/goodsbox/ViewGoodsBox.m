//
//  ScrollViewFavorite.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/6.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewGoodsBox.h"
#import "DB.h"
@implementation ViewGoodsBox
@synthesize lblTitle,gifLoading;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"goodsbox";
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"goods_box"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(68, 30, 200, 40)];
        [self addSubview:lblTitle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
