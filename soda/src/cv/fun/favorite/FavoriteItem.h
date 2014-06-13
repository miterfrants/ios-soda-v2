//
//  FavoriteItem.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/5.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonProtoType.h"

@interface FavoriteItem : ViewProtoType
@property UILabel *lblName;
@property UIImageView *imgViewCover;
@property UILabel *lblAddress;
@property ButtonProtoType *btnDel;
@property ButtonProtoType *btnPhone;
@property UIView *viewCon;
@property NSString *phone;
@property BOOL isTouch;
@property CGPoint touchPoint;
@property double iniOffsetX;
@property int seq;
@property int identification;
-(void)resizeLabel;
-(void)setName:(NSString *)name;
-(void)setAddress:(NSString *)address;
@end
