//
//  ViewControllerTop.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/11.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewControllerTop.h"
#import "ViewControllerRoot.h"
#import "ScrollViewControllerCate.h"
#import "ScrollViewControllerList.h"
#import "ViewTip.h"
#import "FMDatabaseAdditions.h"
#import "Util.h"
#import "DB.h"

@interface ViewControllerTop ()

@end

@implementation ViewControllerTop
@synthesize txtSearch,btnSearch,btnAdd,gv,lblHint,breadCrumbView,btnRefresh,isSearchList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        txtSearch =[[TextViewSearch alloc]init];
        [self.view addSubview:txtSearch];
        btnSearch = [[ButtonSearch alloc]init];
        [self.view addSubview:btnSearch];
        
        btnAdd=[[ButtonAdd alloc]init];
        [self.view addSubview:btnAdd];
        
        lblHint=[[LabelForChangeUILang alloc]init];
        [self.view addSubview:lblHint];
        [lblHint setFrame:CGRectMake(txtSearch.frame.origin.x+10, txtSearch.frame.origin.y, txtSearch.frame.size.width, txtSearch.frame.size.height)];
        [lblHint setFont:txtSearch.font];
        [lblHint setTextColor:[UIColor whiteColor]];
        lblHint.key=@"search";
        
        breadCrumbView=[[BreadCrumbView alloc]init];
        [self.view addSubview:breadCrumbView];
        [breadCrumbView setHidden:YES];
        [self.view setFrame:CGRectMake(0, 0, gv.screenW, 94)];

        btnRefresh=[[ButtonRefresh alloc]init];
        [self.view addSubview:btnRefresh];
        [btnRefresh setHidden:YES];
    }
    return self;
}

-(void)search{
    
}

-(void)pin{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"top:%@",NSStringFromClass(touch.view.class));
    if([touch.view isEqual:txtSearch]){
        NSLog(@"top condition:1");
        [self statusCommonToSearch];
    }else if([touch.view isEqual:breadCrumbView.btnHome] &&
             ([GV getGlobalStatus]==LIST ||
              [GV getGlobalStatus]==LIST_EXPAND ||
              [GV getGlobalStatus]==LIST_EXPAND_WITHKEYBOARD
              )){
        NSLog(@"top condition:2");
        //google analytics list to home
         [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"btn_home"];
         [UserInteractionLog sendAnalyticsView:@"home"];
        [self statusListToCommon];
        ViewControllerRoot* root=(ViewControllerRoot*) gv.viewControllerRoot;
        [root.scrollViewControllerCate animationShowCate];
        [root.scrollViewControllerList animationHideList];
    }else if([touch.view isEqual:btnRefresh] &&
             (
              [GV getGlobalStatus]==LIST ||
              [GV getGlobalStatus]==LIST_EXPAND ||
              [GV getGlobalStatus]==LIST_EXPAND_WITHKEYBOARD
              )
              ){
        NSLog(@"top condition:3");
         [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"btn_refresh"];
        ScrollViewControllerList *sclist=(ScrollViewControllerList *)self.gv.scrollViewControlllerList;
        [sclist refresh];
        return;
    }else if([touch.view isEqual:btnSearch] && [GV getGlobalStatus]==COMMON){
        if(txtSearch.text.length==0){
            ViewTip *tip=(ViewTip *)self.gv.viewTip;
            [tip statusPreviousStatusToTip:txtSearch title:[DB getUI:@"operation_hint"] msg:[DB getUI:@"please_type_search_keyword"]];
        }else{
            NSLog(@"top condition:4");
            ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
            scrollViewControllerCate.selectedButtonCate=scrollViewControllerCate.buttonCateForSearch;
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"btn_search"];
            [UserInteractionLog sendAnalyticsView:@"list"];
            [self statusCommonToList];
        }
    }else if([touch.view isEqual:btnSearch] && [GV getGlobalStatus]==SEARCH){
        if(txtSearch.text.length==0){
            ViewTip *tip=(ViewTip *)self.gv.viewTip;
            [tip statusPreviousStatusToTip:txtSearch title:[DB getUI:@"operation_hint"] msg:[DB getUI:@"please_type_search_keyword"]];
        }else{
            NSLog(@"top condition:5");
            ScrollViewControllerCate *scrollViewControllerCate=(ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
            scrollViewControllerCate.selectedButtonCate=scrollViewControllerCate.buttonCateForSearch;
            NSLog(@"%@",scrollViewControllerCate.buttonCateForSearch);
            [self statusSearchToCommon];
            [self statusCommonToList];
            NSLog(@"%@",scrollViewControllerCate.selectedButtonCate);
        }
    }else if(![touch.view isEqual:breadCrumbView.btnHome] && [GV getGlobalStatus]==LIST){
        NSLog(@"top condition:6");
        return;
    }else{
        NSLog(@"top condition:7");
        [self statusSearchToCommon];
        if([GV getGlobalStatus]==COMMON &&  [touch.view isKindOfClass:[ButtonAdd class]]){
            [UserInteractionLog sendAnalyticsEvent:@"touch" label:@"btn_add_cate"];
            [self addNewSearchCate];
        }
    }
    [super touchesEnded:touches withEvent:event];
}
int iden=0;
int collectionLen=0;
-(void)addNewSearchCate{
    if(txtSearch.text.length==0){
        ViewTip *tip=(ViewTip *)self.gv.viewTip;
        [tip statusPreviousStatusToTip:btnAdd title:[DB getUI:@"operation_hint"] msg:[DB getUI:@"please_type_search_keyword"]];
        return;
    }
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_addNewSearchCate) object:nil];
    [self.gv.FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation, nil] waitUntilFinished:YES];
    
    if(iden==0){
        NSException *e = [NSException
                          exceptionWithName:@"DB Error"
                          reason:@"insert fail"
                          userInfo:nil];
        @throw e;
    }
    
    ViewControllerRoot *root=(ViewControllerRoot *) self.gv.viewControllerRoot;
    ButtonCate *newButtonCate=[[ButtonCate alloc] initWithIconName:@"" frame:CGRectMake(-100, 0, 100, 94) title:@"" name:@"" lang:[DB getSysConfig:@"lang"] keyword:@"" iden:iden];
    newButtonCate.lblTitle.text=txtSearch.text;
    newButtonCate.keyword=txtSearch.text;
    newButtonCate.originalTitle=txtSearch.text;
    newButtonCate.originalKeyword=txtSearch.text;
    newButtonCate.distance=300;
    //這個應該要搬一下 搬到 scrollViewCate底下
    root.scrollViewControllerCate.selectedButtonCate=newButtonCate;
    [root.scrollViewControllerCate.scrollViewCate addSubview:newButtonCate];

    //這邊把contentSize 攝高一點
    NSLog(@"addNewSearchCate:%f",ceil((float)collectionLen/2)*132+20);
    root.scrollViewControllerCate.scrollViewCate.originalHeight=ceil((float)collectionLen/2)*132+20;
    [root.scrollViewControllerCate.scrollViewCate bringSubviewToFront:root.scrollViewControllerCate.scrollViewCate.btnRemoveCate];
    [root.scrollViewControllerCate animationCateSlide];
    [root.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"pin"];
}

-(void)_addNewSearchCate{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO collection (name,google_types,title,keyword,icon,lang,other_source,is_default,sort,distance) VALUES ('%@','%@','%@','%@','%@',(SELECT content FROM sys_config WHERE name='lang'),'',0,(select (sort+0)/2 from collection order by sort limit 1),300)",txtSearch.text,@"",txtSearch.text,txtSearch.text,@""]];
    iden=(int) [db lastInsertRowId];
    collectionLen=[db intForQuery:@"SELECT COUNT(*) FROM collection WHERE lang=(SELECT CONTENT from sys_config WHERE name='lang' LIMIT 1) and name !='search'"];
    [db close];
}

-(void)statusCommonToSearch{
    if([GV getGlobalStatus]!=COMMON){
        return;
    }
    ScrollViewControllerCate *cateVC = (ScrollViewControllerCate *)self.gv.scrollViewControllerCate;
    cateVC.scrollViewCate.scrollEnabled = NO;
    [GV setGlobalStatus:SEARCH];
    [lblHint setText:@""];
    cateVC.scrollViewCate.scrollEnabled = YES;
}
-(void)statusSearchToCommon{
    if([GV getGlobalStatus]!=SEARCH){
        return;
    }
    if([txtSearch.text isEqualToString:@""]){
        [lblHint setText:[DB getUI:@"search"]];
    }
    [txtSearch resignFirstResponder];
    [GV setGlobalStatus:COMMON];
}

-(void)statusSearchToList{
    if([GV getGlobalStatus]!=SEARCH){
        return;
    }
    if([txtSearch.text isEqualToString:@""]){
        [lblHint setText:[DB getUI:@"search"]];
    }
    [txtSearch resignFirstResponder];
    [GV setGlobalStatus:COMMON];
}

-(void)statusListToCommon{
    if(
       [GV getGlobalStatus]!=LIST &&
        [GV getGlobalStatus]!=LIST_EXPAND &&
        [GV getGlobalStatus]!=LIST_EXPAND_WITHKEYBOARD
       ){
        return;
    }
    KeyboardTopInput *keyboardTopInput=(KeyboardTopInput *)self.gv.keyboardTopInput;
    [keyboardTopInput hideKeyboard:nil];
    ScrollViewControllerList *scrollViewControlllerList = (ScrollViewControllerList *)self.gv.scrollViewControlllerList;
    [scrollViewControlllerList.viewFunBar.viewPanelForLocation.txtCenterAdderss resignFirstResponder];
    [scrollViewControlllerList.locationManager stopUpdatingLocation];
    [self animationHideBreadCrumb];
    [GV setGlobalStatus:COMMON];
}

-(void)statusCommonToList{
    if(
       [GV getGlobalStatus]!=COMMON
       ){
        return;
    }
    [GV setGlobalStatus:LIST];
}

-(void)animationShowBreadCrumb:(NSString *)iconName name:(NSString *)name{
    [breadCrumbView setAlpha:0.0f];
    [breadCrumbView setHidden:NO];
    [btnRefresh setAlpha:0.0f];
    [btnRefresh setHidden:NO];
    breadCrumbView.btnSecond.lblCate.text=name;
    UIImage *img=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",self.gv.pathIcon,iconName]];
    [breadCrumbView.btnSecond.imgViewIcon setImage:img];
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [btnAdd setAlpha:0.0f];
         [btnSearch setAlpha:0.0f];
         [lblHint setAlpha:0.0f];
         [txtSearch setAlpha:0.0f];
         [breadCrumbView setAlpha:1.0f];
         [btnRefresh setAlpha:1.0f];
     } completion:^(BOOL finished) {
         if (finished){
             [lblHint setHidden:YES];
             [btnSearch setHidden:YES];
             [txtSearch setHidden:YES];
             [btnAdd setHidden:YES];
         }
     }];
}

-(void)animationHideBreadCrumb{
    [lblHint setHidden:NO];
    [btnSearch setHidden:NO];
    [txtSearch setHidden:NO];
    [btnAdd setHidden:NO];
    
    [UIView animateWithDuration:0.34 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         [btnAdd setAlpha:1.0f];
         [btnSearch setAlpha:1.0f];
         [lblHint setAlpha:1.0f];
         [txtSearch setAlpha:1.0f];
         [breadCrumbView setAlpha:0.0f];
         [btnRefresh setAlpha:0.0f];
     } completion:^(BOOL finished) {
         if (finished){
             [breadCrumbView setHidden:YES];
             [btnRefresh setHidden:YES];
         }
     }];
}

@end
