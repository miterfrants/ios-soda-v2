//
//  GameModel.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/7/2.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import "GameNotification.h"
#import "PopupView.h"

#define GAME_NOTIFICATION_DELAY 3
#define GAME_NOTIFICATION_COMBINE_BETWEEN_SECONDS 3

typedef void (^ExecuteNotificationBlock)(UIImage *icon, NSString *title, NSString *msg);


@interface GameModel : NSObject<PopupViewDelegate>
@property NSOperationQueue *gameQueue;
@property NSOperationQueue *audioQueue;
@property (retain) NSTimer *notificationTimer;
@property NSMutableArray *arrNotificcation;
@property (readwrite,copy) ExecuteNotificationBlock CompletionBlock;
+(GameModel *) shareInstance;
+(void)addGameNotification:(GameNotification *)newNotification;
+(void)initialTimer:(void(^)(UIImage *icon, NSString *title, NSString *msg)) completion;
- (void)setCompletionBlock:(ExecuteNotificationBlock)completionBlock;
@end



