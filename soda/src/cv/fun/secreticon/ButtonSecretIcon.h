//
//  ViewSecretIcon.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/7.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecretIcon.h"
#import "ButtonProtoType.h"
#import "AsyncImgView.h"
#import "ViewProtoType.h"
#import "LoadingCircle.h"

@interface ButtonSecretIcon : ButtonProtoType
@property AsyncImgView *imgViewIcon;
@property UILabel *lblName;
@property int iconId;
@property BOOL isGet;
@property BOOL isSync;
@property NSString *secretId;
@property NSString *tip;
@property NSString *name;
@property NSString *iconName;
@property LoadingCircle *loading;

-(id)initWithSecretIcon:(SecretIcon *) secretIcon frame:(CGRect) frame;
-(void)downloadSecretIcon;
- (void)playAudio;
@end
