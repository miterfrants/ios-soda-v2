//
//  ScrollViewSuggestion.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/24.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewSuggestion.h"
#import "Util.h"
#import "DB.h"
#import "GV.h"
@implementation ViewSuggestion
@synthesize lblTitle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.name=@"suggestion";
        lblTitle=[[LabelForChangeUILang alloc] init];
        lblTitle.key=@"about_us";
        [lblTitle setFont:[GV sharedInstance].fontMenuTitle];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblTitle setFrame:CGRectMake(68, 30, 200, 40)];
        [self addSubview:lblTitle];

        self.scrollView=[[ScrollViewProtoType alloc] initWithFrame:CGRectMake(0, 80, frame.size.width-2, self.gv.screenH-80)];
        [self addSubview:self.scrollView];
        
        self.lblAboutUs=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, frame.size.width-30, self.gv.screenH-80)];
        [self.scrollView addSubview:self.lblAboutUs];
        self.lblAboutUs.numberOfLines=9999999;
        
        self.btnMail=[[ButtonMail alloc] init];
        [self.scrollView addSubview:self.btnMail];
        [self.btnMail setHidden:YES];
        
        self.loading=[[LoadingCircle alloc] initWithFrameAndThick:CGRectMake((frame.size.width-30)/2, 87, 30, 30) thick:1.5];
        [self addSubview:self.loading];
    }
    return self;
}

-(void)getAboutUs{
    [self.loading start];
    NSString *url=[NSString stringWithFormat:@"%@://%@/%@?lang=%@",self.gv.urlProtocol,self.gv.domain,self.gv.controllerAboutUs,[DB getSysConfig:@"lang"]];
    [Util jsonAsyncWithUrl:url target:self cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeout:5 completion:^(NSMutableDictionary *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@",data);
            [self.loading stop];
            double padding=15;
            
            NSString *aboutUs = [[data objectForKey:@"result"] valueForKey:@"about_us"];
            NSString *totalUsers =[[[data objectForKey:@"result"] valueForKey:@"total_users"] stringValue];
            NSString *totalPlaces =[[[data objectForKey:@"result"] valueForKey:@"total_places"] stringValue];
            NSRange rangeOfTotalUsers=[aboutUs rangeOfString:@"{total_users}"];
            NSRange rangeOfTotalPlaces=[aboutUs rangeOfString:@"{total_places}"];
            aboutUs=[aboutUs stringByReplacingOccurrencesOfString:@"{total_users}" withString:totalUsers];
            aboutUs=[aboutUs stringByReplacingOccurrencesOfString:@"{total_places}" withString:totalPlaces];
            if(rangeOfTotalUsers.location<rangeOfTotalPlaces.location){
                rangeOfTotalPlaces.location-=@"{total_users}".length -totalUsers.length;
            }else{
                rangeOfTotalUsers.location-=@"{total_places}".length-totalPlaces.length;
            }
            rangeOfTotalUsers.length=totalUsers.length;
            rangeOfTotalPlaces.length=totalPlaces.length;

            
            NSRange rangeFirst;
            NSRange rangeSecond;
            if(rangeOfTotalPlaces.location<rangeOfTotalUsers.location){
                rangeFirst=rangeOfTotalPlaces;
                rangeSecond=rangeOfTotalUsers;
            }else{
                rangeFirst=rangeOfTotalUsers;
                rangeSecond=rangeOfTotalPlaces;
            }

            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aboutUs];
            
            NSMutableParagraphStyle *parStyleForName=[[NSMutableParagraphStyle alloc] init];
            parStyleForName.lineSpacing=3.5f;
            //中文字以後再調整
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(0)
                                     range:NSMakeRange(0, aboutUs.length)];
            
            [attributedString addAttribute:NSParagraphStyleAttributeName
                                     value:parStyleForName
                                     range:NSMakeRange(0, aboutUs.length)];
            

            //normal
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor darkGrayColor]
                                     range:NSMakeRange(0, rangeFirst.location)];
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.gv.fontArticleForHerbrew
                                     range:NSMakeRange(0,rangeFirst.location)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor whiteColor]
                                     range:NSMakeRange(rangeFirst.location, rangeFirst.length)];
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.gv.fontNormalForHebrew
                                     range:NSMakeRange(rangeFirst.location,rangeFirst.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor darkGrayColor]
                                     range:NSMakeRange(rangeFirst.location+rangeFirst.length,rangeSecond.location- rangeFirst.location-rangeFirst.length)];
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.gv.fontArticleForHerbrew
                                     range:NSMakeRange(rangeFirst.location+rangeFirst.length,rangeSecond.location- rangeFirst.location-rangeFirst.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor whiteColor]
                                     range:NSMakeRange(rangeSecond.location, rangeSecond.length)];
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.gv.fontNormalForHebrew
                                     range:NSMakeRange(rangeSecond.location,rangeSecond.length)];
            
            [attributedString addAttribute:NSForegroundColorAttributeName
                                     value:[UIColor darkGrayColor]
                                     range:NSMakeRange(rangeSecond.location+rangeSecond.length,aboutUs.length- rangeSecond.location-rangeSecond.length)];
            [attributedString addAttribute:NSFontAttributeName
                                     value:self.gv.fontArticleForHerbrew
                                     range:NSMakeRange(rangeSecond.location+rangeSecond.length,aboutUs.length- rangeSecond.location-rangeSecond.length)];

            
            self.lblAboutUs.attributedText=attributedString;
            
            CGSize expectedSizeOfAboutUs=[self.lblAboutUs sizeThatFits:CGSizeMake(self.frame.size.width-padding*2, 90000000)];
            
            [self.lblAboutUs setFrame:CGRectMake(padding, padding/2, self.frame.size.width-padding*2, expectedSizeOfAboutUs.height)];
            
            [self.btnMail setFrame:CGRectMake((self.frame.size.width-44)/2, expectedSizeOfAboutUs.height+padding*2, 44, 44)];
            [self.btnMail setHidden:NO];
            [self.scrollView setContentSize:CGSizeMake(expectedSizeOfAboutUs.width,expectedSizeOfAboutUs.height +padding*2+44+padding+40)];
        });
    } queue:self.gv.backgroundThreadManagement];

}

@end
