//
//  FunctionBar.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/15.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "FunctionBar.h"
#import "Util.h"
@implementation FunctionBar
@synthesize btnLocation,btnFilter,btnSort,viewPanelForLocation,dicViewPanel,viewPanelForFilter,viewPanelForSort,dicButtonFunction;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gv= [GV sharedInstance];
        btnLocation=[[ButtonLocation alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/3, frame.size.height)];
        [self addSubview:btnLocation];
        
        btnFilter=[[ButtonFilter alloc] initWithFrame:CGRectMake(frame.size.width/3, 0, frame.size.width/3, frame.size.height)];
        [self addSubview:btnFilter];
        
        btnSort=[[ButtonSort alloc] initWithFrame:CGRectMake(frame.size.width*2/3, 0, frame.size.width/3, frame.size.height)];
        [self addSubview:btnSort];
        
        viewPanelForLocation=[[ViewPanelForLocation alloc]initWithFrame:CGRectMake(0, 40, self.gv.screenW, 0)];
        [viewPanelForLocation setHidden:NO];
        [viewPanelForLocation setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];
        [self addSubview:viewPanelForLocation];
        
        viewPanelForFilter=[[ViewPanelForFilter alloc]initWithFrame:CGRectMake(0, 40, self.gv.screenW, 0)];
        [viewPanelForFilter setHidden:YES];
        [viewPanelForFilter setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];
        [self addSubview:viewPanelForFilter];

        viewPanelForSort=[[ViewPanelForSort alloc]initWithFrame:CGRectMake(0, 40, self.gv.screenW, 0)];
        [viewPanelForSort setHidden:YES];
        [viewPanelForSort setBackgroundColor:[Util colorWithHexString:@"#8fc9c8ff"]];
        [self addSubview:viewPanelForSort];
        
        dicViewPanel =[[NSMutableDictionary alloc]init];
        [dicViewPanel setObject:viewPanelForLocation forKey:btnLocation.name];
        [dicViewPanel setObject:viewPanelForFilter forKey:btnFilter.name];
        [dicViewPanel setObject:viewPanelForSort forKey:btnSort.name];

        dicButtonFunction=[[NSMutableDictionary alloc]init];
        [dicButtonFunction setObject:btnLocation forKey:btnLocation.name];
        [dicButtonFunction setObject:btnFilter forKey:btnFilter.name];
        [dicButtonFunction setObject:btnSort forKey:btnSort.name];
        self.isExpanded=NO;
    }
    return self;
}

-(void)switchViewPanelWithTargetButton:(ButtonFunction *) btn{
    if(self.isAnimation){
        return;
    }
    if([self.dicViewPanel objectForKey:btn.name]==nil){
        return;
    }
    NSLog(@"FunctionBar.switchViewPanelWithTargetButton");
    //get viewpanel by button property : name
    //clear all button select;
    for(NSString *key in dicButtonFunction){
        if(![btn isEqual:[dicButtonFunction objectForKey:key]]){
            ButtonFunction *offButton= (ButtonFunction *) [dicButtonFunction objectForKey:key];
            offButton.isSelected=NO;
            [offButton toUnHighLightStatus];
        }
    }

    UIView *target=(UIView *)[self.dicViewPanel objectForKey:btn.name];
    self.isAnimation=YES;
    if(btn.isSelected){
        btn.isSelected=NO;
        [btn toUnHighLightStatus];
        [self contractTarget:target];
    }else{
        btn.isSelected=YES;
        [btn toHighLightStatus];
        if([btn.name isEqualToString:@"location"]){
            ViewPanelForLocation *viewPanelForLocaiton=(ViewPanelForLocation *) target;
            //非操作 所以不更新資料來源
            [viewPanelForLocaiton updateCameraCenterAndDB:NO];
        }
        if(self.isExpanded){
            [self slidOn:target offTarget:self.currentShowPanel];
        }else{
            self.currentShowPanel=target;
            [self expandedTarget:target];
        }
    }

}
-(void) slidOn:(UIView *)target offTarget:(UIView *) offTarget{
    [target setFrame:CGRectMake(-self.gv.screenW,40, self.gv.screenW, self.gv.screenH-40-80)];
    if(offTarget==viewPanelForLocation){
        [viewPanelForLocation.txtCenterAdderss stopObserver];
    }
    [target setHidden:NO];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [target setFrame:CGRectMake(0, 40, self.gv.screenW, self.gv.screenH-40-80 )];
         [offTarget setFrame:CGRectMake(self.gv.screenW, 40, self.gv.screenW, self.gv.screenH-40-80 )];
     } completion:^(BOOL finished) {
         if (finished){
             self.isAnimation=NO;
             self.currentShowPanel=target;
             [offTarget setHidden:YES];
             [offTarget setFrame:CGRectMake(0, 40, self.gv.screenW, 0)];
         }
     }];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.viewPanelForLocation.txtCenterAdderss resignFirstResponder];
}

-(void) expandedTarget:(UIView *) target{
    [target setHidden:NO];
    self.isExpanded=YES;
    if(target ==[dicViewPanel objectForKey:btnLocation.name]){
        [viewPanelForLocation.txtCenterAdderss startObserver];
    }else{
        [viewPanelForLocation.txtCenterAdderss stopObserver];
    }
    
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setFrame:CGRectMake(0, 0, self.gv.screenW, self.gv.screenH-80)];
         [target setFrame:CGRectMake(0, 40, self.gv.screenW, self.gv.screenH-40-80 )];
     } completion:^(BOOL finished) {
         if (finished){
             self.isAnimation=NO;
             self.isExpanded=YES;
         }
     }];

}
-(void) contractTarget:(UIView *) target{
    if(target==viewPanelForLocation) {
        [viewPanelForLocation.txtCenterAdderss stopObserver];
    }
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [self setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
         [target setFrame:CGRectMake(0, 40, self.gv.screenW, 0 )];
     } completion:^(BOOL finished) {
         if (finished){
             [target setHidden:YES];
             self.isAnimation=NO;
             self.isExpanded=NO;
         }
     }];
}

-(void)contractAllWithoutAnimation{
    self.isExpanded=NO;
    [self setFrame:CGRectMake(0, 0, self.gv.screenW, 40)];
    for(NSString *key in dicViewPanel){
        UIView *target=(UIView *)[dicViewPanel objectForKey:key];
        [target setHidden:YES];
        [target setFrame:CGRectMake(0, 40, self.gv.screenW, 0 )];
    }

}

-(void)rebackAllButtonWithoutAnimation{
    for(NSString *key in dicButtonFunction){
        ButtonFunction *btn=(ButtonFunction *)[dicButtonFunction objectForKey:key];
        btn.isSelected=NO;
        [btn toUnHighLightStatus];
    }
}

@end
