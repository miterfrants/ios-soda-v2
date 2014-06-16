//
//  ScrollViewList.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewList.h"
#import "ScrollViewControllerList.h"

@implementation ScrollViewList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAutoAnimation=NO;
        self.innerIsAutoAnimation=NO;
        self.delegate=self;
    }
    return self;
}

float memoryDiffY=0;
float memoryY=0;
float negativeStartPos=0;
float positiveStartPos=0;
-(void)iniMarker{
    memoryDiffY=0;
    memoryY=0;
    negativeStartPos=0;
    positiveStartPos=0;
}


-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if(self.isAutoAnimation){
        return;
    }
//    ScrollViewControllerList * controller=(ScrollViewControllerList *) [self getViewController];
    ScrollViewControllerList *scList =(ScrollViewControllerList *)[self getViewController];
    float diffY=scrollView.contentOffset.y-memoryDiffY;
    if(diffY>0 && positiveStartPos==0){
        positiveStartPos=scrollView.contentOffset.y-40+scList.viewFunBar.frame.size.height;
        negativeStartPos=0.0f;
    }else if(diffY<0 && negativeStartPos==0){
        negativeStartPos=scrollView.contentOffset.y-40+scList.viewFunBar.frame.size.height;
        positiveStartPos=0.0f;
    }
    if(scrollView.contentOffset.y>0){
        if(diffY>0){
            memoryY=positiveStartPos;
        }else{
            memoryY=negativeStartPos;
        }
    }

    if(scrollView.contentOffset.y-memoryY<40 && scrollView.contentOffset.y-memoryY>0){
        if(!scList.viewFunBar.isExpanded){
            [scList.viewFunBar setFrame:CGRectMake(scList.viewFunBar.frame.origin.x, scList.viewFunBar.frame.origin.y, scList.viewFunBar.frame.size.width, 40-scrollView.contentOffset.y+memoryY)];
        }
    }else if(scrollView.contentOffset.y-memoryY<=0){
        if(!scList.viewFunBar.isExpanded){
            [scList.viewFunBar setFrame:CGRectMake(scList.viewFunBar.frame.origin.x, scList.viewFunBar.frame.origin.y, scList.viewFunBar.frame.size.width, 40)];
        }
    }else if(scrollView.contentOffset.y-memoryY>=40){
        if(!scList.viewFunBar.isExpanded){
            [scList.viewFunBar setFrame:CGRectMake(scList.viewFunBar.frame.origin.x, scList.viewFunBar.frame.origin.y, scList.viewFunBar.frame.size.width, 0)];
        }
    }

    memoryDiffY=scrollView.contentOffset.y;

    
// button click then get next page;
//    if(controller.createIndex>=controller.targetIndex){
//        controller.isLoadingList=NO;
//    }
//    if(controller.isEndedForSearchResult){
//        return;
//    }
//    if(controller.isLoadingList){
//        return;
//    }
//
//    int currentLoadedIndex=floor(controller.currReulstIndex/self.gv.listBufferCount);
//    if(scrollView.contentOffset.y>=(currentLoadedIndex*20+self.gv.listBufferCount/2)*150-self.gv.screenH+80){
//        [controller loadNextPageList];
//    }
}

- (UIViewController*)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
