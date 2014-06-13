//
//  GooglePlaceAPIPool.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/9.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlaceAPI.h"
@interface GooglePlaceAPIPool : NSObject
@property NSMutableArray *pool;
-(GooglePlaceAPIPool *) initWithKey:(NSMutableArray *) arr;
-(GooglePlaceAPI *) getAPI;
-(void) breakAll;
@end
