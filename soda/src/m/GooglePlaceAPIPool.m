//
//  GooglePlaceAPIPool.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/9.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "GooglePlaceAPIPool.h"

@implementation GooglePlaceAPIPool
-(GooglePlaceAPIPool *) initWithKey:(NSMutableArray *) arr{
    self.pool=[[NSMutableArray alloc] init];
    for(int i=0;i<arr.count;i++){
        GooglePlaceAPI *api=[[GooglePlaceAPI alloc] init];
        api.key=[arr objectAtIndex:i];
        api.isLock=NO;
        api.queue=[[NSOperationQueue alloc]init];
        [api.queue setMaxConcurrentOperationCount:1];
        [self.pool addObject:api];
    }
    return self;
}

-(GooglePlaceAPI *) getAPI{
    if(self.pool.count>0){
        NSSortDescriptor *sort=nil;
        sort=[NSSortDescriptor sortDescriptorWithKey:@"busy" ascending:YES];
        [self.pool sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        return [self.pool objectAtIndex:0];
    }
    return nil;
}

-(void)breakAll{
    for(int i=0;i<self.pool.count;i++){
        GooglePlaceAPI * gpi=(GooglePlaceAPI *)[self.pool objectAtIndex:i];
        gpi.isLock=NO;
    }
}
@end
