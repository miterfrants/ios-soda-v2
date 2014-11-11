//
//  ButtonFunction.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonFunction.h"
#import "Util.h"

@implementation ButtonFunction
@synthesize lblTitle,viewArr,isSelected;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(id)initWithFrameAndName:(CGRect) frame titleKey:(NSString *) titleKey{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=[titleKey lowercaseString];
        lblTitle=[[LabelForChangeUILang alloc]init];
        [lblTitle setFont:self.gv.fontListFunctionTitle];
        [lblTitle setTextAlignment:NSTextAlignmentCenter];
        lblTitle.key=titleKey;
        lblTitle.completeInvoke=@selector(fitTitleSize);
        lblTitle.parentView=self;

        [lblTitle setTextColor:[UIColor whiteColor]];
        [self addSubview:lblTitle];
        
        viewArr=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_function_arr.png"]];
        [self addSubview:viewArr];
        [self fitTitleSize];

    }
    return self;
}

-(void)fitTitleSize{
    CGSize fontSize=[lblTitle sizeThatFits:CGSizeMake(self.frame.size.width-23/2, self.frame.size.height-16/2)];
    [lblTitle setFrame:CGRectMake((self.gv.screenW/3-fontSize.width-16/2-5)/2, 0, fontSize.width, self.frame.size.height)];
    [viewArr setFrame:CGRectMake(lblTitle.frame.origin.x+lblTitle.frame.size.width+5, 18, 23/2, 16/2)];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    //這邊不做toHighLightStatus
    //是因為要展開和顯示同步
    [super touchesBegan:touches withEvent:event];
}

-(void) toHighLightStatus{
    if([GV getGlobalStatus]==LIST){
        if(isSelected){
            [lblTitle setTextColor:[Util colorWithHexString:@"#263439ff"]];
            [viewArr setImage:[UIImage imageNamed:@"list_function_arr_over.png"]];
        }else{
            [lblTitle setTextColor:[Util colorWithHexString:@"#ffffffff"]];
            [viewArr setImage:[UIImage imageNamed:@"list_function_arr.png"]];
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}

-(void)toUnHighLightStatus{
    [lblTitle setTextColor:[Util colorWithHexString:@"#FFFFFFff"]];
    [viewArr setImage:[UIImage imageNamed:@"list_function_arr.png"]];
}
@end
