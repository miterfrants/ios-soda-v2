//
//  File.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "File.h"
#import "FMDatabase.h"
#import "GV.h"
#import "Util.h"

@implementation File
+(void)iniDirectory{
    //check icon directory
    GV *gv=[GV sharedInstance];
    
    NSFileManager *NFM=[NSFileManager defaultManager];
    BOOL isDirectory;
    //icon
    NSError *error = nil;
    if(![NFM fileExistsAtPath:gv.pathIcon isDirectory:&isDirectory] || !isDirectory){
        [NFM createDirectoryAtPath:gv.pathIcon withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if(error!=nil){
        //log error
    }
    
    //db
    error=nil;
    if(![NFM fileExistsAtPath:gv.pathDB isDirectory:&isDirectory] || !isDirectory){
        [NFM createDirectoryAtPath:gv.pathDB withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if(error!=nil){
        //log error
    }
    
    //img
    error=nil;
    if(![NFM fileExistsAtPath:gv.pathImg isDirectory:&isDirectory] || !isDirectory){
        [NFM createDirectoryAtPath:gv.pathImg withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if(error!=nil){
        //log error
    }
}

+(void) downloadDefaultIcon{
    //ini image file
    NSFileManager *NFM=[NSFileManager defaultManager];
    GV *gv=[GV sharedInstance];
    NSDictionary *dicIconResult=[Util jsonWithUrl:[NSString stringWithFormat:@"%@://%@/%@?action=%@",gv.urlProtocol,gv.domain,gv.controllerIcon,gv.actionGetDefaultIcon]];
    NSArray *arrResults=[dicIconResult valueForKey:@"results"];
    for(int i=0;i<arrResults.count;i++){
        NSMutableString *file=[[NSMutableString alloc] initWithString:[arrResults objectAtIndex:i]];
        NSString *pathDest = [NSString stringWithFormat:@"%@/%@",gv.pathIcon,file];
        BOOL isDirectory;
        if(![NFM fileExistsAtPath:pathDest isDirectory:&isDirectory]){
            NSString *url=[NSString stringWithFormat:@"%@/%@",gv.urlIcon,file];
            [Util saveImgFile:url pathDest:pathDest isOverWrite:NO];
        }

        [file insertString:@"_over" atIndex:[file rangeOfString:@"." options:NSBackwardsSearch].location];
        pathDest =[NSString stringWithFormat:@"%@/%@",gv.pathIcon,file];
        if(![NFM fileExistsAtPath:pathDest isDirectory:&isDirectory]){
            NSString *urlOver=[NSString stringWithFormat:@"%@/%@",gv.urlIcon,file];
            [Util saveImgFile:urlOver pathDest:pathDest isOverWrite:NO];
        }
    }
}


@end
