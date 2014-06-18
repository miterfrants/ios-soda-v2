//
//  VariableStore.h
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/8.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "GooglePlaceAPIPool.h"

typedef NS_ENUM(NSUInteger,AppStatus){
    COMMON=1,
    SEARCH=2,
    EDIT_WITHOUT_KEYBOARD=3,
    EDIT_WITH_KEYBOARD=4,
    LIST=5,
    MENU=7,
    TIP=8,
    TIP_SHOWED=9,
    MENU_SUGGESTION=10,
    MENU_PROFILE=11,
    MENU_FAVORITE=12,
    MENU_GOODSBOX=13,
    MENU_COLLECTION=14,
    MENU_CONFIG=15,
    LIST_EXPAND=17,
    LIST_EXPAND_WITHKEYBOARD=18
};

typedef NS_ENUM(NSUInteger,LoginStatus){
    LOGINED=1,
    LOGOUTED=2
};

typedef NS_ENUM(NSUInteger,LoginType){
    Google=1,
    Facebook=2
};

typedef NS_ENUM(NSUInteger,CommentSource){
    CommentSourceGoogle=1,
    CommentSourceFacebook=2,
    CommentSourcePTT=3,
    CommentSourceYELP=4,
    CommentSourceFourSquare=5
};


@interface GV : NSObject
//Controller AND URL
@property NSString *domain;
@property NSString *controllerCollection;
@property NSString *controllerUI;
@property NSString *controllerIcon;
@property NSString *controllerSuggestion;
@property NSString *controllerOfficialSuggestPlace;
@property NSString *controllerReview;
@property NSString *controllerMember;

@property NSString *actionGetDefaultCollection;
@property NSString *actionGetDefaultIcon;
@property NSString *actionAddSuggestion;
@property NSString *actionDownloadSecretIcon;
@property NSString *actionAddOfficialSuggestPlace;
@property NSString *actionDelOfficialSuggestPlace;
@property NSString *actionCheckExistsOfficialSuggestPlace;
@property NSString *actionGetReview;
@property NSString *actionAddReview;
@property NSString *actionGetReviewSelf;
@property NSString *actionGetLocalMember;

@property NSString *controllerPlace;
@property NSString *actionSearchPlace;
@property NSString *actionAddPlace;

@property NSString *urlProtocol;
@property NSString *urlIcon;


//DB
@property NSString *tabCollection;

//path
@property NSString *pathIcon;
@property NSString *pathImg;
@property NSString *pathDB;
@property NSString *pathRoot;

//common
@property NSString* lang;
@property BOOL isSync;
@property float screenH;
@property float screenW;
@property AppStatus status;
@property LoginStatus loginStatus;
@property AppStatus previousStatusForMenu;
@property AppStatus previousStatusForTip;
@property NSString *localUserId;
@property NSString *localUserName;
@property NSString *fbName;
@property UIImage *imgProfile;
@property GooglePlaceAPIPool *gpApiPool;

//view
@property UIViewController* viewControllerRoot;
@property UIViewController* scrollViewControllerCate;
@property UIView *viewTip;
@property UIView *keyboardTopInput;
@property UIViewController *scrollViewControlllerList;

//font
@property UIFont *titleFont;
@property UIFont *contentFont;
@property UIFont *tipTitleFont;
@property UIFont *tipMsgFont;
@property UIFont *fontScrollTitle;
@property UIFont *fontSettingTitle;
@property UIFont *fontMenuTitle;
@property UIFont *fontSettingContent;
@property UIFont *fontSettingPicker;
@property UIFont *fontCountOfReview;
@property UIFont *fontListFunctionTitle;
@property UIFont *fontListFunctionFilter;
@property UIFont *fontListFunctionSorting;
@property UIFont *fontListName;
@property UIFont *fontListAnnounceDate;
@property UIFont *fontButtonText;
@property UIFont *fontInfoWindowTitle;
@property UIFont *fontInfoWindowAddress;
@property UIFont *fontInfoWindowDistance;
@property UIFont *fontFuncFavoriteName;
@property UIFont *fontFuncFavoriteAddress;
@property UIFont *fontNormalForHebrew;

@property LoginType loginType;
@property NSString *jsonGoods;
@property NSString *jsonBadges;
@property NSInteger *intLocalId;
@property NSString *googleWebKey;
@property (nonatomic,retain) NSMutableArray *arrMarker;
@property NSString *listHeight;
@property NSString *listWidth;
@property NSOperationQueue *backgroundThreadManagement;
@property NSOperationQueue *FMDatabaseQueue;
@property NSOperationQueue *GooglePlaceDetailQueue;
@property CLLocation *myLocation;
@property NSDictionary *dicPlaceCate;
@property NSDate *appLaunchDate;
@property NSDate *appExitDate;
@property BOOL isChangeMarkerIndex;
@property float intTopBarHeight;
@property int listBufferCount;
@property BOOL isBlurModel;
@property NSMutableDictionary *dicLang;

// message from which our instance is obtained
+ (GV *)sharedInstance;
+(void)setGlobalStatus:(AppStatus) pStatus;
+(AppStatus)getGlobalStatus;
+(void)setLoginStatus:(LoginStatus) pStatus;
+(LoginStatus)getLoginStatus;
+(BOOL) isLogin;
@end

