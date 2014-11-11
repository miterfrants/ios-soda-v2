//
//  ViewPanelForSort.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/16.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewPanelForSort.h"
#import "Util.h"
#import "ScrollViewControllerCate.h"
#import "DB.h"

@implementation ViewPanelForSort

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.arrSortingKey=[NSArray arrayWithObjects:@"distance",@"rating", @"no", nil];
        self.pickSortingKey=[[UIPickerView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-28)/2, self.gv.screenW,120)];
        self.pickSortingKey.dataSource=self;
        self.pickSortingKey.delegate=self;
        //[self.pickSortingKey setTintColor:[Util colorWithHexString:@"#263439FF"]];
        [self.pickSortingKey setTintColor:[Util colorWithHexString:@"#FFFFFFFF"]];
        [self addSubview:self.pickSortingKey];
    }
    return self;
}

-(void)initialSortinKey:(ButtonCate *)selected{
    for(int i=0;i<self.arrSortingKey.count;i++){
        if([[self.arrSortingKey objectAtIndex:i] isEqualToString:selected.sortingKey]){
            [self.pickSortingKey selectRow:i inComponent:0 animated:NO];
            return;
        }
    }
    [self.pickSortingKey selectRow:self.arrSortingKey.count-1 inComponent:0 animated:NO];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    LabelForChangeUILang *retval = (id)view;
    if (!retval) {
        retval= [[LabelForChangeUILang alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    retval.font = [GV sharedInstance].fontListFunctionSorting;
    retval.text =[DB getUI:[self.arrSortingKey objectAtIndex:row]];
    [retval setTextColor:[UIColor whiteColor]];
    retval.textAlignment=NSTextAlignmentCenter;
    return retval;
}



-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.timerForUpdateSortingKey invalidate];
    self.timerForUpdateSortingKey =nil;
    ScrollViewControllerCate *scrollViewControllerCate =(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    ButtonCate *selected= scrollViewControllerCate.selectedButtonCate;
    [UserInteractionLog sendAnalyticsEvent:@"pick" label:[NSString stringWithFormat:@"list_sort_%@_%@",selected.name,[self.arrSortingKey objectAtIndex:row]]];
    if(selected.sortingKey!=[self.arrSortingKey objectAtIndex:row]){
        NSMutableDictionary *dicParameter=[[NSMutableDictionary alloc] init];
        if(![[self.arrSortingKey objectAtIndex:row] isEqualToString:@"no"]){
            selected.sortingKey=[self.arrSortingKey objectAtIndex:row];
            [dicParameter setValue:[self.arrSortingKey objectAtIndex:row] forKey:@"sorting_key"];
        }else{
            selected.sortingKey=@"";
            [dicParameter setValue:@"" forKey:@"sorting_key"];
        }
        [dicParameter setValue:[NSString stringWithFormat:@"%d",selected.iden] forKey:@"id"];
        self.timerForUpdateSortingKey=[NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(saveSortingKey:) userInfo:dicParameter repeats:NO];
    }
}

-(void)saveSortingKey:(NSTimer *) timer{
    NSLog(@"saveSortingKey");
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_saveSortingKey:) object:timer.userInfo];
    [self.gv.FMDatabaseQueue addOperation:operation];
}
-(void)_saveSortingKey:(NSMutableDictionary *)dicParameter{
    NSLog(@"%@",[NSString stringWithFormat:@"UPDATE collection set sorting_key='%@' WHERE id=%d",
                 [dicParameter valueForKey:@"sorting_key"],
                 [[dicParameter valueForKey:@"id"] intValue]]);
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection set sorting_key='%@' WHERE id=%d",
                       [dicParameter valueForKey:@"sorting_key"],
                       [[dicParameter valueForKey:@"id"] intValue]]];
    [db close];
}
@end
