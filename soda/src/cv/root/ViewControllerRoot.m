//
//  ViewControllerRoot.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/10.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewControllerRoot.h"
#import "ScrollViewControllerCate.h"
#import "ViewTip.h"

#import "ButtonCate.h"
#import "TextFieldEditIconTitle.h"


#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "DB.h"
#import "GV.h"
#import "Util.h"

#import "ReviewHeart.h"
#import "LoadingCircle.h"

@interface ViewControllerRoot ()

@end

@implementation ViewControllerRoot
@synthesize viewControllerTop,scrollViewControllerCate,viewControllerFun,viewBG,scrollViewControllerList,gv;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [GV setGlobalStatus:COMMON];
        gv=[GV sharedInstance];

        
        //view bg
        viewBG =[[UIImageView alloc]init];
        [viewBG setImage:[UIImage imageNamed:@"bg.png"]];
        NSLog(@"%f",self.gv.screenH);
        [viewBG setFrame:CGRectMake(0, 0, gv.screenW,568)];
        [self.view addSubview:viewBG];
        
        viewControllerTop=[[ViewControllerTop alloc]init];
        [self.view addSubview:viewControllerTop.view];
    
        scrollViewControllerCate=[[ScrollViewControllerCate alloc] init];
        [self.view addSubview:scrollViewControllerCate.view];

        viewControllerFun=[[ViewControllerFun alloc] init];
        [self.view addSubview:viewControllerFun.view];
        
        gv.viewControllerRoot=self;
        
        
        scrollViewControllerList=[[ScrollViewControllerList alloc]init];
        [scrollViewControllerList.view setFrame:CGRectMake(gv.screenW, 80, gv.screenW, gv.screenH-80)];
        [self.view addSubview:scrollViewControllerList.view];
        gv.scrollViewControlllerList=scrollViewControllerList;
        
        //popup view;

    }
    return self;
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

}

-(void) customTouchesEnded:(UIViewController *)controller{
    NSLog(@"root controller class:%@", NSStringFromClass(controller.class));
    if(
       [GV getGlobalStatus]==SEARCH &&
       ![controller isKindOfClass:viewControllerTop.class]
       ){
        NSLog(@"root condition 1");
        [viewControllerTop statusSearchToCommon];
    }else if(
        ([GV getGlobalStatus]==EDIT_WITHOUT_KEYBOARD ||
         [GV getGlobalStatus]==EDIT_WITH_KEYBOARD) &&
        ![controller isKindOfClass:scrollViewControllerCate.class]
    ){
        NSLog(@"root condition 2");
        [scrollViewControllerCate statusEditToCommon];
    }else if(
        [GV getGlobalStatus]==MENU
             &&
        ![controller isKindOfClass:ViewControllerFun.class]
    ){
        NSLog(@"root condition 3");
        [viewControllerFun statusMenuToPreviousStatus];
    }else if(
         [GV getGlobalStatus]==LIST
             &&
         [controller isKindOfClass:ScrollViewControllerCate.class]
     ){
        NSLog(@"root condition 4");
        [viewControllerTop animationShowBreadCrumb:scrollViewControllerCate.selectedButtonCate.iconName name:scrollViewControllerCate.selectedButtonCate.lblTitle.text];
        [scrollViewControllerList animationShowList];
        [scrollViewControllerList loadListAndInitWithKeyword:scrollViewControllerCate.selectedButtonCate.keyword type:@"" dist:scrollViewControllerCate.selectedButtonCate.distance center:scrollViewControllerCate.custCenterLocation];
    }else if(
             [GV getGlobalStatus]==LIST
             &&
             [controller isKindOfClass:[ViewControllerTop class]]
             ){
        NSLog(@"root condition 5");
        NSLog(@"%f",scrollViewControllerCate.selectedButtonCate.distance);
        NSLog(@"%f",scrollViewControllerCate.custCenterLocation.latitude);
        NSLog(@"%f",scrollViewControllerCate.custCenterLocation.longitude);
        [viewControllerTop animationShowBreadCrumb:@"search.png" name:viewControllerTop.txtSearch.text];
        [self.viewControllerFun.viewMenu.viewSecret checkSecretByCondition:@"search"];
        [scrollViewControllerCate animationHideCate];
        [scrollViewControllerList animationShowList];
        scrollViewControllerCate.selectedButtonCate.keyword=viewControllerTop.txtSearch.text;
        [scrollViewControllerList loadListAndInitWithKeyword:viewControllerTop.txtSearch.text type:@"" dist:scrollViewControllerCate.custDist center:scrollViewControllerCate.custCenterLocation];
    }else if(
        [GV getGlobalStatus]==TIP
    ){
        NSLog(@"root condition 6");
        [GV setGlobalStatus:TIP_SHOWED];
    }else if(
        [GV getGlobalStatus]==TIP_SHOWED
    ){
        NSLog(@"root condition 7:%d",gv.previousStatusForTip);
        [((ViewTip *)[GV sharedInstance].viewTip) statusTipToPreviousStatus];
    }
}
@end
