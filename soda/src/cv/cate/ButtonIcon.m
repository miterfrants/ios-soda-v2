//
//  ImageViewIcon.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonIcon.h"

@implementation ButtonIcon
@synthesize name,gv,imgViewIcon;

- (id)initWithFrame:(CGRect)frame imgFileName:(NSString*) imgFileName
{
    self = [super initWithFrame:frame];
    if (self) {
        gv=[GV sharedInstance];
        UIImage *img=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",gv.pathIcon,imgFileName]];
        imgViewIcon=[[UIImageView alloc]initWithImage:img];
        [imgViewIcon setFrame:CGRectMake(0, 0, img.size.width/2, img.size.height/2)];
        name=imgFileName;
        [self addSubview:imgViewIcon];
              
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, img.size.width/2, img.size.height/2)];
    }
    return self;
}

-(void)toSelectedStatus{
    NSMutableString *overImgName=[NSMutableString stringWithString:name];
    [overImgName insertString:@"_over" atIndex:[overImgName rangeOfString:@"." options:NSBackwardsSearch].location];
    gv=[GV sharedInstance];
    UIImage *img=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",gv.pathIcon,overImgName]];
    [imgViewIcon setImage:img];
}

-(void)toUnSelectedStatus{
    gv=[GV sharedInstance];
    UIImage *img=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",gv.pathIcon,name]];
    [imgViewIcon setImage:img];
}

@end
