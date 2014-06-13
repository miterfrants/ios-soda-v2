//
//  ViewControllerProtoType.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/18.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewControllerProtoType.h"
#import "ViewControllerRoot.h"

@interface ViewControllerProtoType ()

@end

@implementation ViewControllerProtoType
@synthesize gv;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.gv=[GV sharedInstance];
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
    ViewControllerRoot *root=(ViewControllerRoot *) self.gv.viewControllerRoot;
    [root customTouchesEnded:self];
}
@end
