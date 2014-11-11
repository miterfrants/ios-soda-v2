//
//  GameNotification.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/7/3.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameNotification : NSObject
@property NSDate *createdTime;
@property NSString *title;
@property NSString *msg;
@property UIImage *icon;
@end
