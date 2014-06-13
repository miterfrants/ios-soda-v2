//
//  VariableStore.m
//  PlanB
//
//  Created by Po-Hsiang Hunag on 13/10/8.
//  Copyright (c) 2013年 Po-Hsiang Hunag. All rights reserved.
//

#import "GV.h"
@implementation GV



+ (GV *)sharedInstance
{
    // the instance of this class is stored here
    static GV *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}

+(void)setGlobalStatus:(AppStatus) pStatus{
    GV *gv=[GV sharedInstance];
    gv.status=pStatus;
}

+(AppStatus)getGlobalStatus{
    GV *gv=[GV sharedInstance];
    return gv.status;
}

+(void)setLoginStatus:(LoginStatus) pStatus{
    GV *gv=[GV sharedInstance];
    gv.loginStatus=pStatus;
}

+(LoginStatus)getLoginStatus{
    GV *gv=[GV sharedInstance];
    return gv.loginStatus;
}

+(BOOL) isLogin{
    GV *gv=[GV sharedInstance];
    if(gv.localUserId!=nil){
        return YES;
    }else{
        return NO;
    }
}
@end