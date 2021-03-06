//
//  SocialUtil.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "SocialUtil.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation SocialUtil
+(void)shareReviewWithPlaceName:(NSString *)name comment:(NSString *)comment rating:(double)rating googleId:(NSString *) googleId googleRef:(NSString *) googleRef{
    // Put together the dialog parameters
    if(![[DB getSysConfig:@"share_review"] boolValue]){
        return;
    }
    GV *gv=[GV sharedInstance];
    if(gv.loginType==Facebook) {
        [self shareReviewToFacebookWithPlaceName:name comment:comment rating:rating googleId:googleId googleRef:googleRef];
    }else{
        //google
    }

}

+(void)shareReviewToFacebookWithPlaceName:(NSString *)name comment:(NSString *)comment rating:(double)rating googleId:(NSString *) googleId googleRef:(NSString *) googleRef{
    if(![[DB getSysConfig:@"share_review"] boolValue]){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    GV *gv=[GV sharedInstance];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   [NSString stringWithFormat:@"%@, I sent a score %.2f/5.00", comment,rating], @"caption",
                                   @"New review", @"description",
                                   [NSString stringWithFormat:@"%@://%@/soda/place.aspx?google_id=%@&google_ref=%@&lang=%@",gv.urlProtocol, gv.domain,googleId,googleRef,[DB getSysConfig:@"lang"]], @"link",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
        BOOL isLoaded=false;
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop run];
        while ((!isLoaded) &&
               ([loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate
                                                               distantFuture]]))
        {
            isLoaded=YES;
        }
    });
}

+(void)shareReviewToGoogleWithPlaceName:(NSString *)name comment:(NSString *)comment rating:(double)rating googleId:(NSString *) googleId googleRef:(NSString *) googleRef{
}

+(void)shareFavoriteWithName:(NSString *)name googleId:(NSString *) googleId googleRef:(NSString *)googleRef{
    GV *gv=[GV sharedInstance];
    if(gv.loginType==Facebook) {
        [self shareFavoriteToFacebookWithPlaceName:name googleId:googleId googleRef:googleRef];
    }else{
        [self shareFavoriteToGoogleWithPlaceName:name googleId:googleId googleRef:googleRef];
    }
    
}
+(void)shareFavoriteToFacebookWithPlaceName:(NSString *)name googleId:(NSString *) googleId googleRef:(NSString *)googleRef{
    if(![[DB getSysConfig:@"share_favorite"] boolValue]){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        GV *gv=[GV sharedInstance];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       name, @"name",
                                       @"New favorite", @"description",
                                       [NSString stringWithFormat:@"I add %@ to my favorite place", name], @"caption",
                                       [NSString stringWithFormat:@"%@://%@/soda/place.aspx?google_id=%@&google_ref=%@&lang=%@",gv.urlProtocol, gv.domain,googleId,googleRef,[DB getSysConfig:@"lang"]], @"link",
                                       nil];
        
        // Make the request
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Link posted successfully to Facebook
                                      //NSLog(@"result: %@", result);
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                      NSLog(@"%@", error.description);
                                  }
                              }];
        BOOL isLoaded=false;
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop run];
        while ((!isLoaded) &&
               ([loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate
                                                               distantFuture]]))
        {
            isLoaded=YES;
        }
    });
}
+(void)shareFavoriteToGoogleWithPlaceName:(NSString *)name googleId:(NSString *) googleId googleRef:(NSString *)googleRef{
}

+(void)shareNewSecretIconToFacebookWithIconId:(NSString *)name iconId:(int) iconId{
    if(![[DB getSysConfig:@"share_icon"] boolValue]){
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        GV *gv=[GV sharedInstance];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"I get new secret icon", @"caption",
                                       [NSString stringWithFormat:@"%@://%@/soda/secret_icon.aspx?id=%d&lang=%@",gv.urlProtocol, gv.domain,iconId,[DB getSysConfig:@"lang"]], @"link",
                                       nil];
        
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog(@"result: %@", result);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog(@"%@", error.description);
                              }
                          }];
        BOOL isLoaded=false;
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop run];
        while ((!isLoaded) &&
               ([loop runMode:NSDefaultRunLoopMode beforeDate:[NSDate
                                                               distantFuture]]))
        {
            isLoaded=YES;
        }

    });
}

@end
