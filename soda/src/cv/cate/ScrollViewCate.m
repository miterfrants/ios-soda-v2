//
//  ScrollViewCate.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewCate.h"
#import "ScrollViewControllerCate.h"

@implementation ScrollViewCate
@synthesize originalHeight,btnRemoveCate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        btnRemoveCate=[[ButtonRemoveCate alloc] initWithFrame:CGRectMake(70, 0, 44, 44)];
        
        [btnRemoveCate setHidden:YES];
        [self addSubview:btnRemoveCate];
    }
    return self;
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

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    ScrollViewControllerCate* controller=(ScrollViewControllerCate *)[self getViewController];
    [controller scrollViewDidScroll:scrollView];
    
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    ScrollViewControllerCate* controller=(ScrollViewControllerCate *)[self getViewController];
    [controller scrollViewDidEndDecelerating:scrollView];
}

@end
