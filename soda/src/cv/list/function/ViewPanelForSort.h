//
//  ViewPanelForSort.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonCate.h"

@interface ViewPanelForSort : ViewProtoType <UIPickerViewDataSource,UIPickerViewDelegate>
@property UIPickerView *pickSortingKey;
@property NSArray *arrSortingKey;
@property NSTimer *timerForUpdateSortingKey;
-(void)initialSortinKey:(ButtonCate *)selected;
@end
