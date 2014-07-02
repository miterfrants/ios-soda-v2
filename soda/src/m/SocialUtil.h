//
//  SocialUtil.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GV.h"
#import "Util.h"
#import "DB.h"

@interface SocialUtil : NSObject
+(void)shareReviewWithPlaceName:(NSString *)name comment:(NSString *)comment rating:(double)rating googleId:(NSString *) googleId googleRef:(NSString *) googleRef;
+(void)shareFavoriteWithName:(NSString *)name googleId:(NSString *) googleId googleRef:(NSString *)googleRef;

+(void)shareNewSecretIconToFacebookWithIconId:(NSString *)name iconId:(int) iconId;
@end
