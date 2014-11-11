//
//  ScrollViewControllerCate.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/12.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ScrollViewControllerCate.h"
#import "ViewControllerRoot.h"
#import "TextFieldEditIconTitle.h"
#import "PaddingViewForEditIcon.h"
#import "ButtonSave.h"
#import "ButtonIcon.h"
#import "GV.h"
#import "DB.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Util.h"

@implementation ScrollViewControllerCate
@synthesize scrollViewCate,editTimer,selectedButtonCate
,viewIconEditPeanel,isKeyboardShow
,updateBlurTimer,isSaveData
,viewBG,gv,fileIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scrollViewCate.delegate=self;
        gv=[GV sharedInstance];
        FMDatabase *db=[DB getShareInstance].db;
        
        scrollViewCate=[[ScrollViewCate alloc]init];
        [scrollViewCate setFrame:CGRectMake(0, 0, gv.screenW, gv.screenH-94)];
        
        //fetch collection and generate
        NSString *lang=[DB getSysConfig:@"lang"];
        [db open];
        FMResultSet *results=[db executeQuery:[NSString stringWithFormat:@"SELECT * FROM collection WHERE lang='%@' and is_search=0 ORDER BY sort",lang]];
        int i=0;
        while([results next]){
            NSString *title=[results stringForColumn:@"title"];
            NSString *name=[results stringForColumn:@"name"];
            NSString *keyword=[results stringForColumn:@"keyword"];
            NSString *icon=[results stringForColumn:@"icon"];
            NSString *distance=[results stringForColumn:@"distance"];
            NSString *centerLat=[results stringForColumn:@"center_lat"];
            NSString *centerLng=[results stringForColumn:@"center_lng"];
            NSString *isOnlyShowPhone=[results stringForColumn:@"is_only_phone"];
            NSString *isOnlyShowOpening=[results stringForColumn:@"is_only_opening"];
            NSString *isOnlyShowFavorite=[results stringForColumn:@"is_only_favorite"];
            NSString *rating=[results stringForColumn:@"rating"];
            NSString *isOnlyShowOfficialSuggest=[results stringForColumn:@"is_only_official_suggest"];
            int iden=[results intForColumn:@"id"];
            NSString *sortingKey=[results stringForColumn:@"sorting_key"];
            ButtonCate *buttonCate= [[ButtonCate alloc] initWithIconName:icon frame:CGRectMake(i%2*116+52, floor(i/2)*132, 100, 94) title:title name:name lang:lang keyword:keyword iden:iden];
            buttonCate.distance=[distance doubleValue];
            buttonCate.centerLocation =CLLocationCoordinate2DMake([centerLat floatValue], [centerLng floatValue]);
            buttonCate.isOnlyShowFavorite=[isOnlyShowFavorite boolValue];
            buttonCate.isOnlyShowOfficialSuggest=[isOnlyShowOfficialSuggest boolValue];
            buttonCate.isOnlyShowOpening=[isOnlyShowOpening boolValue];
            buttonCate.isOnlyShowPhone=[isOnlyShowPhone boolValue];
            buttonCate.rating=[rating doubleValue];
            buttonCate.sortingKey=sortingKey;
            [scrollViewCate addSubview:buttonCate];
            i+=1;
        }
        [results close];
        [db close];
        
        //search
        [db open];
        FMResultSet *resultForSearch=[db executeQuery:[NSString stringWithFormat:@"SELECT * FROM collection WHERE lang='%@' and is_search=1 ORDER BY sort",lang]];
        while([resultForSearch next]){
            NSString *titleForSearch=[resultForSearch stringForColumn:@"title"];
            NSString *nameForSearch=[resultForSearch stringForColumn:@"name"];
            NSString *keywordForSearch=[resultForSearch stringForColumn:@"keyword"];
            NSString *iconForSearch=[resultForSearch stringForColumn:@"icon"];
            NSString *distanceForSearch=[resultForSearch stringForColumn:@"distance"];
            NSString *isOnlyShowPhoneForSearch=[resultForSearch stringForColumn:@"is_only_phone"];
            NSString *isOnlyShowOpeningForSearch=[resultForSearch stringForColumn:@"is_only_opening"];
            NSString *isOnlyShowFavoriteForSearch=[resultForSearch stringForColumn:@"is_only_favorite"];
            NSString *ratingForSearch=[resultForSearch stringForColumn:@"rating"];
            NSString *isOnlyShowOfficialSuggestForSearch=[resultForSearch stringForColumn:@"is_only_official_suggest"];
            int idenForSearch=[resultForSearch intForColumn:@"id"];
            NSString *sortingKey=[resultForSearch stringForColumn:@"sorting_key"];
            self.buttonCateForSearch= [[ButtonCate alloc] initWithIconName:iconForSearch frame:CGRectMake(0,0,0,0) title:titleForSearch name:nameForSearch lang:lang keyword:keywordForSearch iden:idenForSearch];
            self.buttonCateForSearch.distance=[distanceForSearch doubleValue];
            self.buttonCateForSearch.isOnlyShowFavorite=[isOnlyShowFavoriteForSearch boolValue];
            self.buttonCateForSearch.isOnlyShowOfficialSuggest=[isOnlyShowOfficialSuggestForSearch boolValue];
            self.buttonCateForSearch.isOnlyShowOpening=[isOnlyShowOpeningForSearch boolValue];
            self.buttonCateForSearch.isOnlyShowPhone=[isOnlyShowPhoneForSearch boolValue];
            self.buttonCateForSearch.rating=[ratingForSearch doubleValue];
            self.buttonCateForSearch.sortingKey=sortingKey;
        }
        [db close];
        self.custCenterLocation = CLLocationCoordinate2DMake([[DB getSysConfig:@"center_lat"] floatValue], [[DB getSysConfig:@"center_lng"] floatValue]);
        self.custDist = [[DB getSysConfig:@"distance"] floatValue];
        if([[DB getSysConfig:@"is_cust_location"] isEqual:@"Y"]){
            self.isCustLocation = YES;
        }else {
            self.isCustLocation = NO;
        }


        //view bg
        float height=188;
        viewBG =[[UIImageView alloc]initWithImage:[self imageByCropping:[UIImage imageNamed:@"bg.png"]  toRect:CGRectMake(0,height , gv.screenW*2, gv.screenH*2-height)]];
        [viewBG setFrame:CGRectMake(0, 0, gv.screenW, gv.screenH-94)];
        [self.view addSubview:viewBG];

        
        //scroll view
        [scrollViewCate setContentSize:CGSizeMake(gv.screenW, ceil((float)i/2)*132+20)];
        scrollViewCate.originalHeight=ceil((float)i/2)*132+20;
        NSLog(@"scrollViewCate originalHeight:%f",(float) ceil((float)i/2)*132+20);
        [self.view addSubview:scrollViewCate];
        [scrollViewCate bringSubviewToFront:scrollViewCate.btnRemoveCate];
        
        //save reference
        gv.scrollViewControllerCate=self;
        
        
        //icon edit panel
        viewIconEditPeanel =[[ViewIconEditPanel alloc] initWithFrame:CGRectMake(0, gv.screenH-94, gv.screenW, 233)];
        [self.view addSubview:viewIconEditPeanel];
        [viewIconEditPeanel setHidden:YES];
        
        //common
        [self.view setFrame:CGRectMake(0, 94, gv.screenW, gv.screenH-94)];

        //listener
        [viewIconEditPeanel.viewEditTitle.txtContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [viewIconEditPeanel.viewEditKeyword.txtContent addTarget:self action:@selector(textKeyWordDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        //keyboard observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}


- (UIImage *)imageByCropping:(UIImage *)imageToCrop toRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

-(UIImage*)imageByCropping2:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    
    //create a context to do our clipping in
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //create a rect with the size we want to crop the image to
    //the X and Y here are zero so we start at the beginning of our
    //newly created context
    
    CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    CGContextClipToRect( currentContext, clippedRect);
    
    //create a rect equivalent to the full size of the image
    //offset the rect by the X and Y we want to start the crop
    //from in order to cut off anything before them
    
    CGRect drawRect = CGRectMake(rect.origin.x * -1,
                                 rect.origin.y * -1,
                                 imageToCrop.size.width,
                                 imageToCrop.size.height);
    
    //draw the image to our clipped context using our offset rect
    
    CGContextDrawImage(currentContext, drawRect, imageToCrop.CGImage);
    
    //pull the image from our cropped context
    
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    //pop the context to get back to the default
    
    UIGraphicsEndImageContext();
    
    //Note: this is autoreleased
    
    return cropped;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch=[[event allTouches]anyObject];
    if(
       [touch.view isKindOfClass:ButtonCate.class] &&
       [GV getGlobalStatus] == COMMON
       ){
        
        self.selectedButtonCate=(ButtonCate *)touch.view;
        [self timerStart];
        
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //clear timer;
    [editTimer invalidate];
    editTimer=nil;
    

    //if status is edit selected button
    UITouch* touch=[[event allTouches]anyObject];
    NSLog(@"cate:%@",NSStringFromClass(touch.view.class));
    if(
       ([GV getGlobalStatus]==EDIT_WITH_KEYBOARD ||
        [GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD) &&
       [touch.view isKindOfClass:ButtonCate.class]
       ){
        NSLog(@"%@",@"condition 1:");
        ButtonCate *btn=(ButtonCate *)touch.view;
        [self selectButtonAndClearAll:btn.iden isRestoreOriginalData:NO];
        viewIconEditPeanel.viewEditTitle.txtContent.text=btn.lblTitle.text;
        viewIconEditPeanel.viewEditKeyword.txtContent.text=btn.keyword;
        [viewIconEditPeanel.scrollViewIcon selectIcon:btn.iconName];
        [viewIconEditPeanel.blurView updateAsynchronously:YES completion:^{}];
        selectedButtonCate=btn;        
    }else if(
        [GV getGlobalStatus]==COMMON &&
        [touch.view isKindOfClass:ButtonCate.class]
    ){
        selectedButtonCate=(ButtonCate *) touch.view;
        //google analytics click button event to common list
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:[NSString stringWithFormat:@"cate_button_%@",selectedButtonCate.name]];
        [UserInteractionLog sendAnalyticsView:@"list"];
        [self statusCommonToList];
    }else if(
             [touch.view isEqual:viewIconEditPeanel.viewEditKeyword.txtContent] ||
             [touch.view isEqual:viewIconEditPeanel.viewEditTitle.txtContent]
             ){
        NSLog(@"%@",@"condition 3:");
        //keyboard will show enhance animation
    }else if(
             //ButtonIcon distinct with BUttonCate
             [touch.view isKindOfClass:[ButtonIcon class]]
    ){
        NSLog(@"%@",@"condition 4:");
        ButtonIcon *btnIcon=(ButtonIcon *) touch.view;
        [viewIconEditPeanel.scrollViewIcon selectIcon:btnIcon.name];
        [selectedButtonCate changeOverIcon:btnIcon.name];
    }else if(
             [touch.view isEqual:viewIconEditPeanel] ||
             [touch.view isEqual:viewIconEditPeanel.blurView]
    ){
        NSLog(@"%@",@"condition 5:");
        [viewIconEditPeanel.viewEditTitle.txtContent resignFirstResponder];
        [viewIconEditPeanel.viewEditKeyword.txtContent resignFirstResponder];
    }else if(
             [touch.view isKindOfClass:[BlurView class]] ||
             [touch.view isKindOfClass:[ViewIconEditPanel class]] ||
             [touch.view isKindOfClass:[ScrollViewIcon class]] ||
             [touch.view isKindOfClass:[ViewIphone4BgForBlurView class]]
    ){
        NSLog(@"%@",@"condition 6:");
      //nothing happen
    }else if(
             [touch.view isKindOfClass:[ViewEditTitle class]]
    ){
        NSLog(@"%@",@"condition 7:");
        ViewEditTitle *target =(ViewEditTitle *) touch.view;
        [target.txtContent becomeFirstResponder];
        [target.txtContent selectAll:self];
    }else if(
             [touch.view isKindOfClass:[PaddingViewForEditIcon class]]
    ){
        NSLog(@"%@",@"condition 8:");
        ViewEditTitle *target =(ViewEditTitle *) touch.view.superview.superview;
        [target.txtContent becomeFirstResponder];
        [target.txtContent selectAll:self];
    }else if([touch.view isEqual:viewIconEditPeanel.btnSave]){
        NSLog(@"%@",@"condition 9:");
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"btn_save_cate"];
        [self saveAllButtonCateToDB];
        return;
    }else if([touch.view isKindOfClass:[ButtonRemoveCate class]]){
        NSLog(@"%@",@"condition 10:");
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[DB getUI:@"remove_confirm"]
                              message:[DB getUI:@"do_you_want_to_remove_it"]
                              delegate:self
                              cancelButtonTitle:[DB getUI:@"no"]
                              otherButtonTitles:[DB getUI:@"yes"],nil];
        [alert show];
        //delete local data on db
        //animation remove cate slide end hide edit panel
    }else{
        NSLog(@"%@",@"condition 12:");
        [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"touch_cancel"];
        [self statusEditToCommon];
    }
    NSLog(@"%@",@"bubble event:");
    [super touchesEnded:touches withEvent:event];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%@",alertView);
    if (buttonIndex == 1) {
        NSLog(@"YES, remove icon");
        [UserInteractionLog sendAnalyticsEvent:@"alert" label:[NSString stringWithFormat:@"remove_cate_%@",selectedButtonCate.name]];
        //這邊很容易 lock db thread
        FMDatabase *db=[DB getShareInstance].db;
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM collection WHERE id=%d",selectedButtonCate.iden]];
        [db close];
        [self animationRemoveCateSlide];
    } else {
        [UserInteractionLog sendAnalyticsEvent:@"alert" label:@"remove_cancel"];
        NSLog(@"NO");
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[event allTouches].anyObject;
    if([touch.view isKindOfClass:[ButtonCate class]]){
        [editTimer invalidate];
        editTimer=nil;
    }
    [super touchesCancelled:touches withEvent:event];
}

//event handle
-(void) scrollViewDidScroll:(id)scrollView{
    [viewIconEditPeanel.blurView setDynamic:YES];
}

-(void) scrollViewDidEndDecelerating:(id)scrollView{
    [viewIconEditPeanel.blurView setDynamic:NO];
}
//custom listener target action
-(void)textFieldDidChange:(id) sender{
    UITextField *txt = (UITextField *)sender;
    selectedButtonCate.lblTitle.text=txt.text;
}

-(void)textKeyWordDidChange:(id) sender{
    UITextField *txt = (UITextField *)sender;
    self.selectedButtonCate.keyword=txt.text;
}

//keyboard logic
-(void)keyboardWillShow:(NSNotification *)note{
    //show keyboard
    if([GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD){
        CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
        [self statusEditWithoutKeyboardToEditWithKeyboard:keyboardSize douration:duration curve:curve];
    }
}

- (void)keyboardWillHide:(NSNotification*)note
{
    CGSize keyboardSize = [[[note userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve=[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue] << 16;
    if(isSaveData){
        [self statusEditWithKeyboardToCommon:keyboardSize douration:duration curve:curve];
        ViewControllerRoot *root=(ViewControllerRoot *)gv.viewControllerRoot;
        [root.viewControllerTop.txtSearch setEnabled:YES];
    }else{
        [self statusEditWithKeyboardToEditWithoutKeyboard:keyboardSize douration:duration curve:curve];
    }
    isSaveData=NO;
}




-(void)timerStart{
    NSLog(@"timerStart");
    [editTimer invalidate];
    editTimer=nil;
    editTimer=[NSTimer scheduledTimerWithTimeInterval:1.45
                                               target:self
                                             selector:@selector(popupEditIconPanel:)
                                             userInfo:nil
                                              repeats:NO];
    
}



-(void) updateBlurViewAndResizeScrollViewContentSize{
    [viewIconEditPeanel.blurView updateAsynchronously:YES completion:^{
        //NSLog(@"finish generate blur view");
    }];
    [scrollViewCate setContentSize:CGSizeMake(gv.screenW,(self.view.frame.size.height-[[viewIconEditPeanel.layer presentationLayer]frame].origin.y)+scrollViewCate.originalHeight)];

}

-(void) hideCom{
    [viewIconEditPeanel setHidden:YES];
}

//animation
-(void) animationShowCate{
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         [self.view setFrame:CGRectMake(0, 94, scrollViewCate.frame.size.width, scrollViewCate.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished){
             [self.viewBG setHidden:NO];
         }
     }];
}
-(void) animationHideCate{
    [self.viewBG setHidden:YES];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         [self.view setFrame:CGRectMake(-scrollViewCate.frame.size.width, 94, scrollViewCate.frame.size.width, scrollViewCate.frame.size.height)];
     } completion:^(BOOL finished) {
         if (finished){
         }
     }];
}
-(void) animationPushEditIconPanelWithKeyboardSize:(CGSize) keyboardSize duraction:(double) duraction curve:(int) curve {
    [viewIconEditPeanel.blurView setDynamic:YES];
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.034
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [UIView animateWithDuration:duraction delay:0.0 options:(curve) animations:^
     {
         [viewIconEditPeanel setFrame:CGRectMake(0, self.view.frame.size.height-233-keyboardSize.height, gv.screenW, 233)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             //NSLog(@"animation end");
             [viewIconEditPeanel.blurView setDynamic:NO];
             [updateBlurTimer invalidate];
             updateBlurTimer=nil;
         }
     }];
}

-(void) animationDownEidtIconPanelWithKeyboardSize:(CGSize) keyboardSize duration:(double) duration curve:(int) curve{
    [viewIconEditPeanel.blurView setDynamic:YES];
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.024
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [UIView animateWithDuration:duration delay:0.0 options:(curve) animations:^
     {
         [viewIconEditPeanel setFrame:CGRectMake(0, self.view.frame.size.height-233, gv.screenW, 233)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [viewIconEditPeanel.blurView setDynamic:NO];
             [updateBlurTimer invalidate];
             updateBlurTimer=nil;
         }
     }];
}

-(void) animationHideEidtIconPanelWithKeyboardSize:(CGSize) keyboardSize duration:(double) duration curve:(int) curve{
    //fix animation to double time and 
    [viewIconEditPeanel.blurView setDynamic:YES];
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.024
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [UIView animateWithDuration:duration*2 delay:0.0 options:(curve) animations:^
     {
         [viewIconEditPeanel setFrame:CGRectMake(0, self.view.frame.size.height, gv.screenW, 233)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [viewIconEditPeanel.blurView setDynamic:NO];
             [updateBlurTimer invalidate];
             updateBlurTimer=nil;
         }
     }];
}

int animationObjectStartCount=0;
int animationObjectFinishCount=0;
-(void) animationRemoveCateSlide{
    animationObjectStartCount=0;
    animationObjectFinishCount=0;
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.024
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];

    NSArray *subviews=[scrollViewCate subviews];
     [scrollViewCate.btnRemoveCate setHidden:YES];
    for(int i=0;i<subviews.count;i++){
        if(![selectedButtonCate isEqual:[subviews objectAtIndex:i]]){
            ButtonCate *target=[subviews objectAtIndex:i];
            float targetX=0;
            float targetY=target.frame.origin.y;
            if(target.frame.origin.y>selectedButtonCate.frame.origin.y){
                if(target.frame.origin.x==52){
                    targetX=-100;
                }else if(target.frame.origin.x==168){
                    targetX=52;
                }
            }else if(target.frame.origin.y==selectedButtonCate.frame.origin.y &&
                     target.frame.origin.x>selectedButtonCate.frame.origin.x
                     ){
                targetX=52;
            }
            if(targetX==0){
                continue;
            }
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
             {
                 [target setFrame:CGRectMake(targetX, targetY, target.frame.size.width, target.frame.size.height)];
             } completion:^(BOOL finished) {
                 if (finished)
                 {
                     if(target.frame.origin.x<0){
                        [target setFrame:CGRectMake(168+100+52, target.frame.origin.y-132, target.frame.size.width, target.frame.size.height)];
                         animationObjectStartCount+=1;
                         [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
                          {
                              [target setFrame:CGRectMake(168, target.frame.origin.y, target.frame.size.width, target.frame.size.height)];
                          } completion:^(BOOL finished) {
                              if(finished){
                                  animationObjectFinishCount+=1;
                                  if(animationObjectFinishCount==animationObjectStartCount){
                                      [selectedButtonCate removeFromSuperview];
                                      self.scrollViewCate.originalHeight=floor((scrollViewCate.subviews.count-4)/2)*132+50+94;
                                      [scrollViewCate setContentSize:CGSizeMake(gv.screenW,(self.view.frame.size.height-(self.gv.screenH-viewIconEditPeanel.frame.size.height)+scrollViewCate.originalHeight))];

                                      NSLog(@"finish all animation remove cate ");
                                      [updateBlurTimer invalidate];
                                      updateBlurTimer=nil;
                                  }
                              }
                          }];
                     }
                 }
             }];
        }
    }
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [selectedButtonCate setAlpha:0.0f];
     } completion:^(BOOL finished) {
         if (finished)
         {

             scrollViewCate.originalHeight=floor((scrollViewCate.subviews.count-4)/2)*132+50+94;
             [selectedButtonCate removeFromSuperview];
            viewIconEditPeanel.viewEditKeyword.txtContent.text=@"";
            viewIconEditPeanel.viewEditTitle.txtContent.text=@"";
             [viewIconEditPeanel.scrollViewIcon selectIcon:nil];
         }
     }];
}


-(void) animationCateSlide{
    animationObjectStartCount=0;
    animationObjectFinishCount=0;

    NSArray *subviews=self.scrollViewCate.subviews;
    for(int i=0;i<subviews.count;i++){
        if([[subviews objectAtIndex:i] isKindOfClass:[ButtonCate class]]){
            ButtonCate *btnCate=(ButtonCate*)[subviews objectAtIndex:i];
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
             {
                 if(btnCate.frame.origin.x <0){
                     [btnCate setFrame:CGRectMake(52, btnCate.frame.origin.y, 100, 94)];
                 }else if(btnCate.frame.origin.x+116+52>gv.screenW){
                     [btnCate setFrame:CGRectMake(btnCate.frame.origin.x+116+52, btnCate.frame.origin.y, btnCate.frame.size.width, btnCate.frame.size.height)];
                 }else{
                     [btnCate setFrame:CGRectMake(btnCate.frame.origin.x+116, btnCate.frame.origin.y, btnCate.frame.size.width, btnCate.frame.size.height)];
                 }

             } completion:^(BOOL finished) {
                 if (finished)
                 {
                     if(btnCate.frame.origin.x>gv.screenW){
                         animationObjectStartCount+=1;
                         [btnCate setFrame:CGRectMake(-btnCate.frame.size.width, btnCate.frame.origin.y+132, btnCate.frame.size.width, btnCate.frame.size.height)];
                         [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
                          {
                              
                              [btnCate setFrame:CGRectMake(52, btnCate.frame.origin.y, btnCate.frame.size.width, btnCate.frame.size.height)];
                          } completion:^(BOOL finished) {
                              if (finished)
                              {
                                  animationObjectFinishCount+=1;
                                  if(animationObjectStartCount==animationObjectFinishCount){
                                      [self popupEditIconPanel:nil];
                                  }
                              }
                          }];

                     }
                 }
             }];
        }
    }
}


-(void) animationHideIconEditPanel{
    double duration=0.34;
    if(isKeyboardShow){
        duration=duration*2;
    }
    
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.024
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];
    [viewIconEditPeanel.blurView setDynamic:YES];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         
         [viewIconEditPeanel setFrame:CGRectMake(0, self.view.frame.size.height, gv.screenW, 233)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [self hideCom];
             [viewIconEditPeanel.blurView setDynamic:NO];
             [updateBlurTimer invalidate];
             updateBlurTimer=nil;
             isSaveData=NO;
         }
     }];
}

-(void) popupEditIconPanel:(id)sender{
    //change app status to edit without keyboard;
    [self.view.superview bringSubviewToFront:self.view];
    [GV setGlobalStatus:EDIT_WITHOUT_KEYBOARD];
    [UserInteractionLog sendAnalyticsEvent:@"touch_hold" label:[NSString stringWithFormat:@"btn_cate_%@",selectedButtonCate.name]];
    //prevent use touch search textfield firing keyboardWillHide
    //and status is EditWithKeyboard change to EditWithoutKeyboard;
    //then keyboard animation not complete, the root invoke statusEditToCommon;
    ViewControllerRoot *root=(ViewControllerRoot *)gv.viewControllerRoot;
    [root.viewControllerTop.txtSearch setEnabled:NO];
    
    //clear all button except target
    ButtonCate *target=selectedButtonCate;
    [self selectButtonAndClearAll:target.iden isRestoreOriginalData:NO];
    target.isEdit =YES;
    
    //show and initial with viewIconEditPanel
    [viewIconEditPeanel setHidden:NO];

    viewIconEditPeanel.viewEditTitle.txtContent.text=target.lblTitle.text;
    viewIconEditPeanel.viewEditKeyword.txtContent.text=target.keyword;
    viewIconEditPeanel.blurView.underlyingView=self.view;
    [viewIconEditPeanel.scrollViewIcon iniWithIconFile];
    [viewIconEditPeanel.scrollViewIcon selectIcon:target.iconName];
    [viewIconEditPeanel.blurView setDynamic:YES];

    //show animation
    [updateBlurTimer invalidate];
    updateBlurTimer=nil;
    updateBlurTimer=[NSTimer scheduledTimerWithTimeInterval:0.038
                                                     target:self
                                                   selector:@selector(updateBlurViewAndResizeScrollViewContentSize)
                                                   userInfo:nil
                                                    repeats:YES];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [viewIconEditPeanel setFrame:CGRectMake(0, self.view.frame.size.height-233, gv.screenW, 233)];
     } completion:^(BOOL finished) {
         if (finished)
         {
             [viewIconEditPeanel.blurView setDynamic:NO];
             [updateBlurTimer invalidate];
             updateBlurTimer=nil;
         }
     }];
}

-(IBAction)saveAllButtonCateToDB{
    NSArray *views=self.scrollViewCate.subviews;
    int countOfCateButton=0;
    for(int i=0;i<views.count;i++){
        if( [[views objectAtIndex:(NSUInteger)i] isKindOfClass:ButtonCate.class]){
            countOfCateButton+=1;
            ButtonCate* btn=(ButtonCate *) [views objectAtIndex:(NSUInteger)i];
            
            FMDatabase *db=[DB getShareInstance].db;
            [db open];

            [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection SET title='%@',keyword='%@',icon='%@' WHERE id=%d",btn.lblTitle.text,btn.keyword,btn.iconName,btn.iden]];
            [db executeUpdate:[NSString stringWithFormat:@"UPDATE collection SET icon='%@' WHERE name='%@' AND is_default=0",btn.iconName,btn.name]];
            [db close];
            btn.originalTitle=btn.lblTitle.text;
            btn.originalKeyword=btn.keyword;
            btn.originalIconName=btn.iconName;
            btn.isEdit=NO;
            [btn toCommonStatus];
        }
    }
    isSaveData=YES;
    ViewControllerRoot *root=(ViewControllerRoot *) self.gv.viewControllerRoot;
    [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"change_icon"];
    [self statusEditToCommon];
}

-(void)selectButtonAndClearAll:(int)iden isRestoreOriginalData:(BOOL) isRestoreOriginalData
{
    NSArray *views=self.scrollViewCate.subviews;
    if(iden<0){
        [scrollViewCate.btnRemoveCate setHidden:YES];
    }
    for(int i=0;i<views.count;i++){
        if( [[views objectAtIndex:(NSUInteger)i] isKindOfClass:ButtonCate.class]){
            ButtonCate* btn=(ButtonCate *) [views objectAtIndex:(NSUInteger)i];
            if(isRestoreOriginalData){
                btn.lblTitle.text=btn.originalTitle;
                [btn changeIcon:btn.originalIconName];
            }
            if(iden==btn.iden){
                btn.isEdit=YES;
                [scrollViewCate.btnRemoveCate setHidden:NO];
                [scrollViewCate.btnRemoveCate setFrame:CGRectMake(btn.frame.origin.x+70, btn.frame.origin.y-10, 44, 44)];
                [btn toTouchStatus];
                continue;
            }
            btn.isEdit=NO;
            [btn toCommonStatus];
            
        }
    }
}

//status change
-(void)statusEditToCommon{
    if(
       [GV getGlobalStatus]!=EDIT_WITHOUT_KEYBOARD &&
       [GV getGlobalStatus]!=EDIT_WITH_KEYBOARD
    ){
        return;
    }
    if([GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD){
        [self statusEditWithoutKeyboardToCommon];
    }else if([GV getGlobalStatus]==EDIT_WITH_KEYBOARD){
        [self.viewIconEditPeanel.viewEditKeyword.txtContent resignFirstResponder];
        [self.viewIconEditPeanel.viewEditTitle.txtContent resignFirstResponder];
    }
}
-(void)statusEditWithoutKeyboardToCommon{
    if(
       [GV getGlobalStatus]!=EDIT_WITHOUT_KEYBOARD
       ){
        return;
    }
    
    [self selectButtonAndClearAll:-1 isRestoreOriginalData:YES];
    [self animationHideIconEditPanel];
    [GV setGlobalStatus:COMMON];
    ViewControllerRoot *root=(ViewControllerRoot *)gv.viewControllerRoot;
    [root.viewControllerTop.txtSearch setEnabled:YES];
}
-(void)statusEditWithKeyboardToCommon:(CGSize) keyboardSize douration:(double) duration curve:(int) curve{
    if(
       [GV getGlobalStatus]!=EDIT_WITH_KEYBOARD
       ){
        return;
    }
    [self selectButtonAndClearAll:-1 isRestoreOriginalData:YES];
    [self animationHideEidtIconPanelWithKeyboardSize:keyboardSize duration:duration curve:curve];
    [GV setGlobalStatus:COMMON];
}

-(void)statusEditWithoutKeyboardToEditWithKeyboard:(CGSize) keyboardSize douration:(double) duration curve:(int) curve{
    if(
       [GV getGlobalStatus]!=EDIT_WITHOUT_KEYBOARD
       ){
        return;
    }
    
    [self animationPushEditIconPanelWithKeyboardSize:keyboardSize  duraction:duration curve:curve];
    
    [GV setGlobalStatus:EDIT_WITH_KEYBOARD];
}

//to without
-(void)statusEditWithKeyboardToEditWithoutKeyboard:(CGSize) keyboardSize douration:(double) duration curve:(int) curve{
    if(
       [GV getGlobalStatus]!=EDIT_WITH_KEYBOARD
       ){
        return;
    }
    [self animationDownEidtIconPanelWithKeyboardSize:keyboardSize duration:duration curve:curve];
    [GV setGlobalStatus:EDIT_WITHOUT_KEYBOARD];
}

//to without
-(void)statusCommonToList{
    if(
       [GV getGlobalStatus]!=COMMON
       ){
        return;
    }
    [self animationHideCate];
    [GV setGlobalStatus:LIST];
}

@end

