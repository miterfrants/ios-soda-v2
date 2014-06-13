//
//  ScrollViewIcon.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/17.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewIcon.h"
#import "GV.h"
#import "Util.h"
#import "BUttonIcon.h"

@implementation ScrollViewIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 216+17-115,[GV sharedInstance].screenW ,115)];
        //[self setBackgroundColor:[Util colorWithHexString:@"#FFFFFF7F"]];
        [self setContentSize:CGSizeMake(600, 115)];
        //[self setBackgroundColor:[Util colorWithHexString:@"#FF00007F"]];
    }
    return self;
}
-(void) iniWithIconFile{
    NSArray *subviews=self.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[ButtonIcon class]]){
            [[subviews objectAtIndex:i] removeFromSuperview];
        }
    }
    NSError * error;
    NSFileManager *nfm=[NSFileManager defaultManager];
    NSArray * directoryContents = [nfm contentsOfDirectoryAtPath:[GV sharedInstance].pathIcon error:&error];
    int currIndex=0;
    for(int i=0;i<directoryContents.count;i++){
        if([[directoryContents objectAtIndex:i] rangeOfString:@"_over"].length>0){
            continue;
        }
        if([[directoryContents objectAtIndex:i] rangeOfString:@".png"].length==0){
            continue;
        }
        NSDictionary *attributes = [nfm attributesOfItemAtPath:[[GV sharedInstance].pathIcon stringByAppendingPathComponent:[directoryContents objectAtIndex:i]]
                                                        error:&error];
        unsigned long long size = [attributes fileSize]; //Note this isn't a pointer
        if(size==0){
            continue;
        }
        ButtonIcon *buttonIcon=[[ButtonIcon alloc] initWithFrame:CGRectMake(currIndex*100, 10, 0, 0) imgFileName:[directoryContents objectAtIndex:i]];
        [self addSubview:buttonIcon];
        currIndex+=1;
    }
    [self setContentSize:CGSizeMake(currIndex*100,115)];
}

-(void)selectIcon:(NSString *) name{
    NSArray *arrViews=[self subviews];
    for(int i=0;i<arrViews.count;i++){
        if([[arrViews objectAtIndex:i] isKindOfClass:[ButtonIcon class]]){
            ButtonIcon * icon=(ButtonIcon *) [arrViews objectAtIndex:i];
            if([icon.name isEqual:name]){
                [icon toSelectedStatus];
            }else{
                [icon toUnSelectedStatus];
            }
        }
    }
}

@end
