//
//  GooglePlaceAPI.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/9.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlaceAPI : NSObject
@property BOOL isLock;
@property int busy;
@property NSString *key;
@property NSOperationQueue *queue;
@end
