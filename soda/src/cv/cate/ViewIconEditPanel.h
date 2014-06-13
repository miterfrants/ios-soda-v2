//
//  ViewPanel.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/13.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlurView.h"
#import "ButtonSave.h"
#import "ViewEditTitle.h"
#import "ScrollViewIcon.h"
#import "ViewProtoType.h"
@interface ViewIconEditPanel : ViewProtoType
@property ViewEditTitle* viewEditTitle;
@property ViewEditTitle* viewEditKeyword;
@property UIImageView* imgViewEditBg;
@property BlurView* blurView;
@property ButtonSave *btnSave;
@property ScrollViewIcon *scrollViewIcon;
@end
