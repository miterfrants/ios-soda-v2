//
//  ListItem.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "AsyncImgView.h"
#import "FXBlurView.h"
#import "ButtonProtoType.h"
#import "ButtonFlag.h"
#import "ButtonPhone.h"
#import "ButtonLike.h"
#import "ButtonShowMap.h"
#import "ButtonReview.h"
#import "BUttonLight.h"
#import "ScrollViewDetailMap.h"
#import "ScrollViewDetailBase.h"
#import "ScrollViewDetailOpening.h"
#import "ScrollViewDetailReview.h"
#import "LoadingCircle.h"
#import "ViewArrow.h"

@interface ListItem : ViewProtoType
@property AsyncImgView *imgViewBg;
@property FXBlurView *blurBg;
@property UIView *maskBg;
@property UIView *viewTopBorder;
@property UIView *viewBottomBorder;
@property NSTimer *updateBlurTimer;
@property UILabel *lblName;
@property NSString *strPhone;
@property float rate;
@property int seq;
@property ButtonPhone *btnPhone;
@property ButtonLike *btnFavorite;
@property ButtonShowMap *btnShowMap;
@property ButtonReview *btnReview;
@property ButtonFlag *btnFlag;
@property ButtonLight *btnLigth;
@property NSString *googleId;
@property NSString *googleRef;
@property NSString *googleTypes;
@property NSString *address;
@property NSString *expandName;
@property double distance;
@property double lat;
@property double lng;
@property int countFinishAllAnimation;
@property BOOL isOpening;
@property BOOL isExistOpeningData;
@property BOOL isFavorite;
@property BOOL isOfficialSuggest;
@property BOOL isShow;
@property BOOL isExpanded;
@property NSMutableArray *arrReview;
@property NSString *name;
@property NSMutableDictionary *dicDetailPanel;
@property NSMutableDictionary *jsonBaseData;
@property UIView *scrollViewCurrentExpanded;
@property ScrollViewDetailBase *scrollViewDetailBase;
@property ScrollViewDetailReview *scrollViewDetailReview;
@property ScrollViewDetailMap *scrollViewDetailMap;
@property ScrollViewDetailOpening *scrollViewDetailOpening;
@property double poseOfCurrentReview;
@property UIView *viewGradientBgForName;
@property UIView *viewMiddleLigthBorder;
@property UIView *viewMiddleDarkBorder;
@property LoadingCircle *loadingCircle;
@property LoadingCircle *loadingForSendReview;
@property UIView *contentCon;
@property ViewArrow *viewArrow;
//for review
@property UILabel *lblIForComment;
@property UIView *viewTopBgForComment;
@property UIView *viewBottomBgForComment;
@property ButtonComment *btnComment;

-(void) loadPicFromGoogle:(NSString *) ref;
-(void) call;
-(void) addLoadGooglePlaceDetailToQueue:(NSString *) ref;
-(void) placeElement;
-(void) displaySelf;
-(void)expandDetail:(NSString *) detailName animate:(BOOL) animate;
-(void) clearReview;
-(void)contractDetailWithAll:(BOOL) animate;
-(void)saveReview;
-(void)generateReview;
-(BOOL) initialItemData:(NSMutableDictionary *)data isFromLocal:(BOOL) isFromLocal;
@end
