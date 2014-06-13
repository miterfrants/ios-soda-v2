//
//  ScrollViewFavorite.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/6.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewExpandedPanel.h"
#import "ScrollViewProtoType.h"
@interface ViewSecret : ViewExpandedPanel
@property UIImageView *gifLoading;
@property ScrollViewProtoType *scrollViewSecret;
-(void) checkSecretByCondition:(NSString *) tip;
@end
