//
//  ButtonLike.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonLike.h"
#import "DB.h"
#import "FMDatabaseAdditions.h"
#import "ListItem.h"
#import "Util.h"
#import "AppDelegate.h"
#import "SocialUtil.h"

@implementation ButtonLike
@synthesize imgViewFill;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star.png"]];
        [self addSubview:self.viewBg];
        [self.viewBg setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        imgViewFill=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star_fill.png"]];
        [self addSubview:imgViewFill];
        [imgViewFill setFrame:CGRectMake(22, 22, 0, 0)];
    }
    return self;
}

-(void) animationToFill{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [imgViewFill setFrame:CGRectMake(0, 0, 44, 44)];
         } completion:^(BOOL finished) {
             if (finished){
             }
         }];
    });
}

-(void) animationToEmpty{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.28 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
         {
             [imgViewFill setFrame:CGRectMake(22, 22, 0, 0)];
         } completion:^(BOOL finished) {
             if (finished){
             }
         }];
    });
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([GV getGlobalStatus]!=LIST &&
       [GV getGlobalStatus]!=LIST_EXPAND &&
       [GV getGlobalStatus]!=LIST_EXPAND_WITHKEYBOARD
       ){
        return;
    }
    ListItem *item=(ListItem *)self.superview.superview;
    if([self.gv.localUserId isEqual:@"2"]){
        NSString *action=self.gv.actionAddOfficialSuggestPlace;
        if([self isFavorite]){
            action=self.gv.actionDelOfficialSuggestPlace;
        }
        NSString *url=[NSString stringWithFormat:@"%@://%@/%@?action=%@&google_id=%@&access_token=%@&member_id=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerOfficialSuggestPlace,action,item.googleId,[FBSession activeSession].accessTokenData.accessToken,self.gv.localUserId];

        [Util stringAsyncWithUrl:url cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:4 completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            NSLog(@"official suggest place:%@",result);
        } queue:self.gv.backgroundThreadManagement];
    }
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_updateFavorite) object:nil];
    [self.gv.FMDatabaseQueue addOperation:operation];
    [super touchesEnded:touches withEvent:event];
}

-(void) _updateFavorite{
    FMDatabase *db=[DB getShareInstance].db;
    ListItem *item=(ListItem*) self.superview.superview;
    [db open];
    int countForPlace=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favorite where google_id='%@'",item.googleId]];
    if(countForPlace>0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animationToEmpty];
        });
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM favorite where google_id='%@'",item.googleId]];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animationToFill];
            [SocialUtil shareFavoriteWithName:item.name googleId:item.googleId googleRef:item.googleRef];
        });
        [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO favorite (name,google_id,google_type,google_ref,phone,address,lat,lng) VALUES ('%@','%@','%@','%@','%@','%@',%f,%f)",item.lblName.text,item.googleId,item.googleTypes,item.googleRef,item.strPhone,item.address,item.lat,item.lng]];
    }
    [db close];
}

-(void) checkDB{
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_checkDB) object:nil];
    [self.gv.FMDatabaseQueue addOperation:operation];
}
-(void) _checkDB{
    FMDatabase *db=[DB getShareInstance].db;
    ListItem *item=(ListItem*) self.superview.superview;
    [db open];
    int countForPlace=[db intForQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favorite where google_id='%@'",item.googleId]];
    if(countForPlace==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animationToEmpty];
        });

    }else{
        _isFavorite=YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self animationToFill];
        });
    }
    [db close];
}

bool _isFavorite;
-(BOOL) isFavorite{
    _isFavorite=NO;
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_checkDB) object:nil];
    [self.gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
    return _isFavorite;
}
@end
