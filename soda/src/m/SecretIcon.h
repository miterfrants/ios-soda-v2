//
//  SecretIcon.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/7.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecretIcon : NSObject
@property NSString *name;
@property BOOL isSync;
@property BOOL isGet;
@property NSString *tip;
@property int icon_id;
@property NSString *secretId;
@property NSString *updatedTime;
@property int sort;
@end
