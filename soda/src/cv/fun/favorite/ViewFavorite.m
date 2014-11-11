//
//  ScrollViewFavorite.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/6.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewFavorite.h"
#import "DataFavoriteItem.h"
#import "DB.h"
#import "FavoriteItem.h"
#import "Util.h"

@implementation ViewFavorite
@synthesize lblTitle,gifLoading;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"favorite";
        lblTitle=[[LabelForChangeUILang alloc] init];
        lblTitle.key=@"favorite";
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(68, 30, 200, 40)];
        [self addSubview:lblTitle];
        self.scrollViewFavorite=[[ScrollViewProtoType alloc] initWithFrame:CGRectMake(0,80,frame.size.width,self.gv.screenH)];
        [self addSubview:self.scrollViewFavorite];
        
        self.lblEmptyInfo=[[LabelForChangeUILang alloc] init];
        [self.lblEmptyInfo setFont:self.gv.fontNormalForHebrew];
        [self.lblEmptyInfo setTextColor:[UIColor whiteColor]];
        [self.lblEmptyInfo setFrame:CGRectMake((frame.size.width-200)/2, 120, 200, 40)];
        self.lblEmptyInfo.key=@"no_data";
        [self.lblEmptyInfo setTextAlignment:NSTextAlignmentCenter];
        [self.lblEmptyInfo setHidden:YES];
        [self addSubview:self.lblEmptyInfo];
        self.arrFavoriteItem=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)showEmptyInformation{
    
}

-(void)generateFavoriteItem{
    NSMutableArray *arrResult=[self getFavoriteDataFromDB];
    double currPos=10;
    if(arrResult.count==0){
        [self.lblEmptyInfo setHidden:NO];
    }else{
        [self.lblEmptyInfo setHidden:YES];
    }
    for(int i=0;i<arrResult.count;i++){
        DataFavoriteItem *dataItem=(DataFavoriteItem *)[arrResult objectAtIndex:i];
        FavoriteItem *favoriteItem=[[FavoriteItem alloc]initWithFrame:CGRectMake(0, currPos, self.frame.size.width, 25)];
        favoriteItem.phone=dataItem.phone;
        favoriteItem.seq=i;
        favoriteItem.lat=dataItem.lat;
        favoriteItem.lng=dataItem.lng;
        favoriteItem.identification=dataItem.identification;
        [favoriteItem setName:dataItem.name];
        [favoriteItem setAddress:dataItem.address];
        [favoriteItem resizeLabel];
        currPos+=favoriteItem.frame.size.height+20;
        [self.arrFavoriteItem addObject:favoriteItem];
        [self.scrollViewFavorite addSubview:favoriteItem];
    }
    [self.scrollViewFavorite setContentSize:CGSizeMake(self.frame.size.width, currPos+80)];

}

NSMutableArray *_arrFavorite=nil;
-(NSMutableArray *)getFavoriteDataFromDB{
    _arrFavorite=nil;
    _arrFavorite=[[NSMutableArray alloc]init];
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_getFavoriteDataFromDB) object:nil];
    [[GV sharedInstance].FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation,nil] waitUntilFinished:YES];
    return _arrFavorite;
}

-(void)_getFavoriteDataFromDB{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    FMResultSet *result=[db executeQuery:@"SELECT * FROM favorite ORDER BY id DESC"];
    while([result next]){
        DataFavoriteItem *data=[[DataFavoriteItem alloc] init];
        data.name=[result stringForColumn:@"name"];
        data.identification=[result intForColumn:@"id"];
        data.address=[result stringForColumn:@"address"];
        data.phone=[result stringForColumn:@"phone"];
        data.google_id=[result stringForColumn:@"google_id"];
        data.lat=[result doubleForColumn:@"lat"];
        data.lng=[result doubleForColumn:@"lng"];
        [_arrFavorite addObject:data];
    }
    [db close];
}

-(void)clearFavoriteItem{
    for(int i=0;i<self.arrFavoriteItem.count;i++){
        [[self.arrFavoriteItem objectAtIndex:i] removeFromSuperview];
    }
    self.arrFavoriteItem=nil;
    self.arrFavoriteItem=[[NSMutableArray alloc] init];
}

@end
