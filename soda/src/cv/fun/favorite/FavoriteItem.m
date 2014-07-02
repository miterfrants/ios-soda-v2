//
//  FavoriteItem.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/6/5.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "FavoriteItem.h"
#import "Util.h"
#import "ViewFavorite.h"
#import "DB.h"

@implementation FavoriteItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.viewCon=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.viewCon];
        self.viewCon.userInteractionEnabled=NO;
        self.clipsToBounds=YES;
        
        self.lblAddress =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
        self.lblAddress.numberOfLines=3;
        [self.viewCon addSubview:self.lblAddress];
        
        self.lblName =[[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
        self.lblName.numberOfLines=3;
        [self.viewCon addSubview:self.lblName];
        
        self.btnPhone=[[ButtonProtoType alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        self.btnPhone.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"phone.png"]];
        self.btnPhone.iconOverNameForProtoType=@"phone_over.png";
        self.btnPhone.iconNameForProtoType=@"phone.png";
        [self.btnPhone.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self.btnPhone addSubview:self.btnPhone.viewBg];
        [self addSubview:self.btnPhone];
        [self.btnPhone setAlpha:0.0f];
        self.btnPhone.userInteractionEnabled=NO;
        [self.btnPhone addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnDel=[[ButtonProtoType alloc]initWithFrame:CGRectMake(self.frame.size.width-44, 0, 44, 44)];
        self.btnDel.viewBg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remove.png"]];
        self.btnDel.iconOverNameForProtoType=@"remove_over.png";
        self.btnDel.iconNameForProtoType=@"remove.png";
        [self.btnDel.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self.btnDel addSubview:self.btnDel.viewBg];
        [self addSubview:self.btnDel];
        [self.btnDel setAlpha:0.0f];
        [self.btnDel addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setName:(NSString *)name{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:name];
    
    NSMutableParagraphStyle *parStyleForName=[[NSMutableParagraphStyle alloc] init];
    parStyleForName.lineSpacing=2.0f;
    //中文字以後再調整
    [attributedString addAttribute:NSKernAttributeName
                             value:@(0)
                             range:NSMakeRange(0, name.length)];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:parStyleForName
                             range:NSMakeRange(0, name.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:self.gv.fontNormalForHebrew
                             range:NSMakeRange(0, name.length)];

    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[Util colorWithHexString:@"#FFFFFFFF"]
                             range:NSMakeRange(0, name.length)];

    self.lblName.attributedText=attributedString;
}
-(void)call{
    [Util phoneCall:self.phone];
}
bool isDelete=NO;
-(void)_del{
    FMDatabase *db=[DB getShareInstance].db;
    [db open];
    NSLog([NSString stringWithFormat:@"DELETE FROM favorite WHERE id=%d",self.identification]);
    isDelete=[db executeUpdate:[NSString stringWithFormat:@"DELETE FROM favorite WHERE id=%d",self.identification]];
    [db close];
}
-(void)del{
    isDelete=NO;
    NSInvocationOperation *operation=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(_del) object:nil];
    [[GV sharedInstance].FMDatabaseQueue addOperations:[NSArray arrayWithObjects:operation,nil] waitUntilFinished:YES];
    if(!isDelete){
        NSLog(@"del fail");
        return;
    }else{
        NSLog(@"del success");
    }
    double delHeight=self.frame.size.height;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0.0f)];
        //after move top;
        ViewFavorite * parent=(ViewFavorite *) self.superview.superview;
        for(int i=(int)parent.arrFavoriteItem.count-1;i>self.seq;i--){
            FavoriteItem *item=[parent.arrFavoriteItem objectAtIndex:i];
            [[parent.arrFavoriteItem objectAtIndex:i] setFrame:CGRectMake(item.frame.origin.x, item.frame.origin.y-delHeight-20, item.frame.size.width, item.frame.size.height)];
        }
        [parent.scrollViewFavorite setContentSize:CGSizeMake(parent.scrollViewFavorite.frame.size.width, parent.scrollViewFavorite.contentSize.height-delHeight-20)];
    } completion:^(BOOL finished) {
        if(finished){
            
        }
    }];

    
}

-(void)setAddress:(NSString *)address{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:address];
    
    NSMutableParagraphStyle *parStyleForName=[[NSMutableParagraphStyle alloc] init];
    parStyleForName.lineSpacing=2.0f;
    //中文字以後再調整
    [attributedString addAttribute:NSKernAttributeName
                             value:@(0)
                             range:NSMakeRange(0, address.length)];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:parStyleForName
                             range:NSMakeRange(0, address.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:self.gv.fontHintForHebrew
                             range:NSMakeRange(0, address.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[Util colorWithHexString:@"#666666FF"]
                             range:NSMakeRange(0, address.length)];
    
    self.lblAddress.attributedText=attributedString;
}

-(void)resizeLabel{
    CGSize expectNameSize =[self.lblName sizeThatFits:CGSizeMake(self.lblName.frame.size.width, 99999)];
    [self.lblName setFrame:CGRectMake(self.lblName.frame.origin.x, self.lblName.frame.origin.y, expectNameSize.width, expectNameSize.height)];
    
    CGSize expectAddressSize =[self.lblAddress sizeThatFits:CGSizeMake(self.lblAddress.frame.size.width, 99999)];
    [self.lblAddress setFrame:CGRectMake(self.lblAddress.frame.origin.x, self.lblName.frame.origin.y+expectNameSize.height, self.lblAddress.frame.size.width, expectAddressSize.height)];
    
    if(expectNameSize.height+expectAddressSize.height<44){
        [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, 44)];
    }else{
        [self setFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, expectNameSize.height+expectAddressSize.height)];
    }

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouch=YES;
    UITouch *touch=[[event allTouches]anyObject];
    self.touchPoint = [touch locationInView:touch.view];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.isTouch){
        UITouch *touch=[[event allTouches]anyObject];

        CGPoint location = [touch locationInView:touch.view];
        if(abs(location.x-self.touchPoint.x)>5){
            ScrollViewProtoType *scrollViewParent=(ScrollViewProtoType *)self.superview;
            scrollViewParent.scrollEnabled=NO;
        }
        [self.viewCon setFrame:CGRectMake(self.iniOffsetX+(location.x-self.touchPoint.x)*0.7, 0, self.frame.size.width, self.frame.size.height)];
        
        if(self.viewCon.frame.origin.x<0){
            [self.btnPhone setAlpha:0];
            [self.btnDel setAlpha:fabs(self.viewCon.frame.origin.x)/30];
        }else if(self.viewCon.frame.origin.x>0){
            [self.btnPhone setAlpha:(self.viewCon.frame.origin.x/30)];
            [self.btnDel setAlpha:0];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.iniOffsetX=self.viewCon.frame.origin.x;
    double targetX=0;
    if(self.iniOffsetX>10){
        targetX=30;
    }else if(self.iniOffsetX<-10){
        targetX=-30;
    }
    ScrollViewProtoType *scrollViewParent=(ScrollViewProtoType *)self.superview;
    scrollViewParent.scrollEnabled=YES;
    [UIView animateWithDuration:0.20 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.viewCon setFrame:CGRectMake(targetX, 0, self.viewCon.frame.size.width, self.frame.size.height)];
        self.iniOffsetX=targetX;
        if(targetX==30){
            [self.btnDel setAlpha:0];
            [self.btnPhone setAlpha:1];
        }else if(targetX==-30){
            [self.btnDel setAlpha:1];
            [self.btnPhone setAlpha:0];
        }else{
            [self.btnDel setAlpha:0];
            [self.btnPhone setAlpha:0];
        }
    } completion:^(BOOL finished) {
        if(finished){
            if(targetX==30){
                self.btnPhone.userInteractionEnabled=YES;
                self.btnDel.userInteractionEnabled=NO;
            }else if(targetX==-30){
                self.btnPhone.userInteractionEnabled=NO;
                self.btnDel.userInteractionEnabled=YES;
            }else{
                self.btnPhone.userInteractionEnabled=NO;
                self.btnDel.userInteractionEnabled=NO;
            }
        }
    }];
}

@end
