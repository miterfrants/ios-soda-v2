//
//  ButtonCate.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonProtoType.h"
#import "GV.h"

@interface ButtonCate : ButtonProtoType
@property UIImageView *imgViewIcon;
@property NSString *iconName;
@property UILabel *lblTitle;
@property UIView *viewColorOverlay;
@property NSString *name;
@property NSString *lang;
@property NSString *keyword;
@property NSString *originalKeyword;
@property NSString *originalTitle;
@property NSString *originalIconName;
@property double distance;
@property int iden;
@property BOOL isOnlyShowPhone;
@property BOOL isOnlyShowOpening;
@property BOOL isOnlyShowFavorite;
@property BOOL isOnlyShowOfficialSuggest;
@property double rating;
@property NSString *sortingKey;
@property GV *gv;
@property BOOL isEdit;
@property CLLocationCoordinate2D centerLocation;
-(id)initWithIconName:(NSString *)pIconName frame:(CGRect)frame title:(NSString *) title name:(NSString*) pName lang:(NSString *) pLang keyword:(NSString *) pKeyword iden:(int) pIden;
-(void)toCommonStatus;
-(void)toTouchStatus;
-(void)changeIcon:(NSString *) iconName;
-(void)changeOverIcon:(NSString *) pIconName;
-(void)updateCollection;
@end
