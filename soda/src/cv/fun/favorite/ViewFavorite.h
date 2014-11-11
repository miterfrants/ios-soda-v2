//
//  ScrollViewFavorite.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/6.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ScrollViewProtoType.h"

@interface ViewFavorite : ViewExpandedPanel
@property ScrollViewProtoType *scrollViewFavorite;
@property UIImageView *gifLoading;
@property NSMutableArray *arrFavoriteItem;
@property UISwipeGestureRecognizer *swipeLeftRecognizer;
@property LabelForChangeUILang *lblEmptyInfo;
-(void)generateFavoriteItem;
-(void)clearFavoriteItem;
@end
