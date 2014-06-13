//
//  ButtonCate.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonCate.h"
#import "Util.h"
#import "ScrollViewControllerCate.h"
#import "ViewControllerRoot.h"


@implementation ButtonCate
@synthesize imgViewIcon,lblTitle,viewColorOverlay
            ,name,lang,isEdit,originalTitle,iconName,gv
            ,originalIconName,iden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithIconName:(NSString *)pIconName frame:(CGRect)frame title:(NSString *) title name:(NSString*) pName lang:(NSString *) pLang keyword:(NSString *) pKeyword iden:(int) pIden{
    self = [super initWithFrame:frame];
    if (self) {
        gv=[GV sharedInstance];
        iconName=pIconName;
        originalIconName=pIconName;
        UIImage *imgIcon=[UIImage imageWithContentsOfFile:[self pathOfImage]];
        imgViewIcon=[[UIImageView alloc] initWithImage:imgIcon];
        [imgViewIcon setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        lblTitle =[[UILabel alloc]init];
        UIFont *font=[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
        [lblTitle setFont:font];
        [lblTitle setText:title];
        originalTitle=title;
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [lblTitle setFrame:CGRectMake(0, 55, 100, 60)];
        self.name=[NSString stringWithString:pName];
        self.lang=[NSString stringWithString:pLang];
        self.keyword=pKeyword;
        self.iden= pIden;

        [self addSubview:imgViewIcon];
        [self addSubview:lblTitle];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if([GV getGlobalStatus]==COMMON){
        [self toTouchStatus];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(!self.isEdit){
        [self.highlightTimer invalidate];
        self.highlightTimer=nil;
        self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toCommonStatus) userInfo:nil repeats:NO];
    }
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isEdit){
        return;
    }
    if(self.isCanceled){
        return;
    }
    [self toCommonStatus];
    [super touchesCancelled:touches withEvent:event];
}

-(void)toTouchStatus{
    UIImage *imgIcon=[UIImage imageWithContentsOfFile:[self pathOfOverImage]];
    [imgViewIcon setImage:imgIcon];
    [lblTitle setTextColor:[Util colorWithHexString:@"#263439FF"]];
}

-(void)toCommonStatus{
    if(isEdit){
        return;
    }
    UIImage *imgIcon=[UIImage imageWithContentsOfFile:[self pathOfImage]];
    [imgViewIcon setImage:imgIcon];
    [lblTitle setTextColor:[Util colorWithHexString:@"#FFFFFFFF"]];
}

-(NSString *)pathOfImage{
    if(iconName==nil || [iconName isEqual:@""]){
        return @"";
    }
    return [NSString stringWithFormat:@"%@/%@",gv.pathIcon,iconName];
}
-(NSString *)pathOfOverImage{
    if(iconName==nil || [iconName isEqual:@""]){
        return @"";
    }
    NSMutableString *pImgOverPath=[NSMutableString stringWithString:[self pathOfImage]];
    [pImgOverPath insertString:@"_over" atIndex:[pImgOverPath rangeOfString:@"." options:NSBackwardsSearch].location];
    return pImgOverPath;
}

-(void)changeIcon:(NSString *) pIconName{
    iconName=pIconName;
    UIImage *imgIcon=[UIImage imageWithContentsOfFile:[self pathOfImage]];
    [imgViewIcon setImage:imgIcon];
}
-(void)changeOverIcon:(NSString *) pIconName{
    iconName=pIconName;
    UIImage *imgIcon=[UIImage imageWithContentsOfFile:[self pathOfOverImage]];
    [imgViewIcon setImage:imgIcon];
}

@end