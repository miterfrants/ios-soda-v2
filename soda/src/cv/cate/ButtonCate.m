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
#import "DB.h"

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
        UIFont *font=self.gv.fontNormalForHebrew;
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
//only change lange
-(void)updateCollection{
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_updateCollection) object:nil];
    [self.gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
}

//這裡的center 和 dist 都改為同一來源
-(void) setCenterLocation:(CLLocationCoordinate2D)centerLocation{
    ScrollViewControllerCate *parent = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    parent.custCenterLocation = centerLocation;
}

-(CLLocationCoordinate2D) centerLocation{
    ScrollViewControllerCate *parent = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    return parent.custCenterLocation;
}

-(void) setDistance:(double)distance{
    ScrollViewControllerCate *parent = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    parent.custDist = distance;
}

-(double) distance{
    ScrollViewControllerCate *parent = (ScrollViewControllerCate *) self.gv.scrollViewControllerCate;
    return parent.custDist;
}


-(void)_updateCollection{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    int intOnlyShowPhone=0;
    int intOnlyOpening=0;
    int intOnlyFavorite=0;
    int intOnlyOfficialSuggest=0;
    if(self.isOnlyShowPhone){
        intOnlyShowPhone=1;
    }
    if(self.isOnlyShowOpening){
        intOnlyOpening=1;
    }
    if(self.isOnlyShowFavorite){
        intOnlyFavorite=1;
    }
    if(self.isOnlyShowOfficialSuggest){
        intOnlyOfficialSuggest=1;
    }
    
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection SET distance=%f,center_lat=%f,center_lng=%f,is_only_phone=%d,is_only_opening=%d,is_only_favorite=%d,rating=%f,is_only_official_suggest=%d,sorting_key='%@' where id=%d",self.distance,self.centerLocation.latitude,self.centerLocation.longitude,intOnlyShowPhone,intOnlyOpening,intOnlyFavorite,self.rating,intOnlyOfficialSuggest,self.sortingKey,self.iden]];
    
    //update sys_config center_lag center_lng
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config SET content=%f where name='center_lat'",self.centerLocation.latitude]];
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE sys_config SET content=%f where name='center_lng'",self.centerLocation.longitude]];
    [db close];
}
@end
