//
//  ViewMenu.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ButtonMenu.h"
#import "ButtonLogout.h"
#import "ButtonFb.h"
#import "ButtonGoogle.h"
#import "ButtonForPersonal.h"
#import "ViewProfile.h"
#import "ViewSuggestion.h"
#import "ViewConfig.h"
#import "ViewFavorite.h"
#import "ViewSecret.h"
#import "ViewGoodsBox.h"

@interface ViewMenu : ViewProtoType
@property ButtonFb *btnFb;
@property ButtonGoogle *btnGoogle;
@property ButtonForPersonal *btnGoodsBox;
@property ButtonForPersonal *btnFavorite;
@property ButtonForPersonal *btnCollection;
@property ButtonMenu *btnSuggestion;
@property ButtonMenu *btnConfig;
@property ButtonMenu *btnProfile;
@property UIView *viewBorder;
@property UIView *viewEdge;
@property ViewProfile *viewProfile;
@property ViewSuggestion *viewSuggestion;
@property ViewConfig *viewConfig;
@property ViewFavorite *viewFavorite;
@property ViewSecret *viewSecret;
@property ViewGoodsBox *viewGoodsBox;

@property BOOL isExpand;
-(void) changeToLoginView;
-(void) changeToUnloginView:(BOOL) isIni;
-(void)addLineBorder;
-(void)addGearBorder;
-(void)addCircleBorder;
-(void)clearBorder;

@end
