//
//  ScrollViewControllerCate.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewCate.h"
#import "ButtonCate.h"
#import "ViewIconEditPanel.h"
#import "ViewControllerProtoType.h"
#import "GV.h"

@interface ScrollViewControllerCate : ViewControllerProtoType<UIScrollViewDelegate>
@property ScrollViewCate *scrollViewCate;
@property NSTimer *editTimer;
@property ButtonCate *selectedButtonCate;
@property ViewIconEditPanel *viewIconEditPeanel;
@property UIImageView *imgViewEditBg;
@property BOOL isKeyboardShow;
@property BOOL isSaveData;
@property NSTimer *updateBlurTimer;
@property UIImageView *viewBG;
@property int fileIndex;
@property ButtonCate *buttonCateForSearch;
-(void)selectButtonAndClearAll:(int)iden isRestoreOriginalData:(BOOL) isRestoreOriginalData;

-(void)animationShowCate;
-(void)animationHideCate;
-(void) animationHideIconEditPanel;

-(void) animationPushEditIconPanelWithKeyboardSize:(CGSize) keyboardSize duraction:(double) duraction curve:(int) curve;

-(void) animationDownEidtIconPanelWithKeyboardSize:(CGSize) keyboardSize duration:(double) duration curve:(int) curve;

-(void) animationCateSlide;

-(void)statusEditToCommon;
-(void)statusCommonToList;
-(void)statusEditWithoutKeyboardToEditWithKeyboard:(CGSize) keyboardSize douration:(double) duration curve:(int) curve;
-(void)statusEditWithKeyboardToEditWithoutKeyboard:(CGSize) keyboardSize douration:(double) duration curve:(int) curve;
-(void)statusEditWithoutKeyboardToCommon;
-(void)statusEditWithKeyboardToCommon:(CGSize) keyboardSize douration:(double) duration curve:(int) curve;
@end
