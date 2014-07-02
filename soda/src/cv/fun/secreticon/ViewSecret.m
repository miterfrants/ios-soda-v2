//
//  ScrollViewFavorite.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/6.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewSecret.h"
#import "DB.h"
#import "ButtonSecretIcon.h"

@implementation ViewSecret
@synthesize lblTitle,gifLoading,scrollViewSecret;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"secreticon";
        lblTitle=[[UILabel alloc] init];
        lblTitle.text=[DB getUI:@"icon_collection"];
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(68, 30, 200, 40)];
        [self addSubview:lblTitle];
        
        scrollViewSecret=[[ScrollViewProtoType alloc] initWithFrame:CGRectMake(0,80,frame.size.width,self.gv.screenH)];
        [self addSubview:scrollViewSecret];
    }
    return self;
}
-(void) checkSecretByCondition:(NSString *) tip{
    NSLog(@"ViewSecret.checkSecretByCondition:len %d",(int)scrollViewSecret.subviews.count);
    for(int i=0;i<scrollViewSecret.subviews.count;i++){
        if([[scrollViewSecret.subviews objectAtIndex:i] isKindOfClass:[ButtonSecretIcon class]]){
           ButtonSecretIcon *icon= (ButtonSecretIcon *)[scrollViewSecret.subviews objectAtIndex:i];
            if([icon.tip isEqual:tip] && !icon.isGet){
                NSLog(@"ViewSecret.checkSecretByCondition:%@ download icon",icon.name);
                //peter modify  3秒內只播一次 
                [icon playAudio];
                [icon downloadSecretIcon];
            }
        }
    }
}
@end
