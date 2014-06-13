//
//  ViewMenu.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewMenu.h"
#import "Util.h"
#import "DarkEdgeLayer.h"
#import "LightEdgeLayer.h"

@implementation ViewMenu
@synthesize gv,btnFb,btnGoogle,btnFavorite,btnGoodsBox,btnCollection,btnSuggestion,btnConfig,viewBorder,btnProfile,viewEdge,viewProfile,viewSuggestion,viewConfig,viewFavorite,viewSecret,viewGoodsBox;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self ini:frame];

    }
    return self;
}

-(void) ini:(CGRect) frame{
    [self setFrame:CGRectMake(-211-51.5-16, 0, 262.5, gv.screenH)];
    [self setBackgroundColor:[UIColor blueColor]];
    viewBorder= [[UIView alloc]initWithFrame:frame];
    viewEdge=[[UIView alloc]initWithFrame:frame];
    
    viewProfile=[[ViewProfile alloc]initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [self addSubview:viewProfile];
    [viewProfile setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    
    viewSuggestion=[[ViewSuggestion alloc]initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [self addSubview:viewSuggestion];
    [viewSuggestion setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    
    viewConfig=[[ViewConfig alloc]initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [viewConfig setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    [self addSubview:viewConfig];
    
    viewFavorite=[[ViewFavorite alloc] initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [viewFavorite setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    [self addSubview:viewFavorite];
    
    viewSecret=[[ViewSecret alloc] initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [viewSecret setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    [self addSubview:viewSecret];
    
    viewGoodsBox=[[ViewGoodsBox alloc] initWithFrame:CGRectMake(0, 0, 211, gv.screenH)];
    [viewGoodsBox setBackgroundColor:[Util colorWithHexString:@"#8dc7c640"]];
    [self addSubview:viewGoodsBox];
    
    
    [self addSubview:viewEdge];
    btnFb=[[ButtonFb alloc] initWithFrame:CGRectMake(211+7.5, 78, 44, 44) name:@"facebook"];
    [self addSubview:btnFb];

    btnProfile=[[ButtonMenu alloc] initWithFrame:CGRectMake(211+7.5, 78, 44, 44) name:@"profile"];
    [self addSubview:btnProfile];
    [btnProfile setHidden:YES];
    
    btnGoogle=[[ButtonGoogle alloc] initWithFrame:CGRectMake(211+7.5, 124.5, 44, 44) name:@"google"];
    [self addSubview:btnGoogle];
    
    [self addEdgeByY:176];
    
    btnFavorite=[[ButtonForPersonal alloc] initWithFrame:CGRectMake(211+7.5, 184.5, 44, 44) name:@"favorite"];
    [self addSubview:btnFavorite];
    
    btnGoodsBox=[[ButtonForPersonal alloc] initWithFrame:CGRectMake(211+7.5, 231, 44, 44) name:@"goodsbox"];
    [self addSubview:btnGoodsBox];
    
    btnCollection=[[ButtonForPersonal alloc] initWithFrame:CGRectMake(211+7.5, 277.5, 44, 44) name:@"secreticon"];
    [self addSubview:btnCollection];
    
    [self addEdgeByY:329];
    
    btnSuggestion=[[ButtonMenu alloc] initWithFrame:CGRectMake(211+7.5, 336.5, 44, 44) name:@"suggestion"];
    [self addSubview:btnSuggestion];
    
    btnConfig=[[ButtonMenu alloc] initWithFrame:CGRectMake(211+7.5, 383, 44, 44) name:@"config"];
    [self addSubview:btnConfig];
    
    
    [self addEdgeByY:434.5];
    [self addGearBorder];
    [self addSubview:viewBorder];
}

-(void) addEdgeByY:(int) y{
    DarkEdgeLayer *darkBorderLayer = [DarkEdgeLayer layer];
    [darkBorderLayer iniSelf];
    LightEdgeLayer *lightBorderLayer = [LightEdgeLayer layer];
    [lightBorderLayer iniSelf];
    [darkBorderLayer setPosition:CGPointMake(211, y)];
    [lightBorderLayer setPosition:CGPointMake(211, y+1)];
    [viewEdge.layer addSublayer:darkBorderLayer];
    [viewEdge.layer addSublayer:lightBorderLayer];
}

-(void) addGearBorder{
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(211+51.5, 0)];
    [linePath addLineToPoint:CGPointMake(211+51.5, 33.5)];
    [linePath moveToPoint: CGPointMake(211+51.5, 65)];
    [linePath addLineToPoint:CGPointMake(211+51.5, gv.screenH)];
    borderLayer.path=linePath.CGPath;
    borderLayer.strokeColor = [Util colorWithHexString:@"#FFFFFFFF"].CGColor;
    [viewBorder.layer addSublayer:borderLayer];
    
    CAShapeLayer *gearBorderLayer=[CAShapeLayer layer];
    linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(211+51.5, 33.5)];
    [linePath addCurveToPoint:CGPointMake(211+55.5,34) controlPoint1:CGPointMake(211+51.5, 33.5) controlPoint2:CGPointMake(211+53, 32)];
    [linePath addCurveToPoint:CGPointMake(211+56.5,37) controlPoint1:CGPointMake(211+55.5, 35) controlPoint2:CGPointMake(211+56.5, 37)];
    [linePath addCurveToPoint:CGPointMake(211+60,38.5) controlPoint1:CGPointMake(211+56.5,37) controlPoint2:CGPointMake(211+59,38.5)];
    [linePath addCurveToPoint:CGPointMake(211+63,37.8) controlPoint1:CGPointMake(211+60,38.5) controlPoint2:CGPointMake(211+63,37.8)];
    [linePath addCurveToPoint:CGPointMake(211+66.7,45.5) controlPoint1:CGPointMake(211+63,37.4) controlPoint2:CGPointMake(211+66.7,45.5)];
    [linePath addCurveToPoint:CGPointMake(211+63.7,48.5) controlPoint1:CGPointMake(211+66.7,45.5) controlPoint2:CGPointMake(211+63.7,48.5)];
    [linePath addCurveToPoint:CGPointMake(211+63.7,50.5) controlPoint1:CGPointMake(211+63.7,48.5) controlPoint2:CGPointMake(211+63.7,50.5)];
    [linePath addCurveToPoint:CGPointMake(211+66.4,53.5) controlPoint1:CGPointMake(211+63.7,50.5) controlPoint2:CGPointMake(211+66.4,53.5)];
    [linePath addCurveToPoint:CGPointMake(211+63,59.5) controlPoint1:CGPointMake(211+66.4,53.5) controlPoint2:CGPointMake(211+63,59.5)];
    [linePath addCurveToPoint:CGPointMake(211+59,59.1) controlPoint1:CGPointMake(211+63,59.5) controlPoint2:CGPointMake(211+59,59.1)];
    [linePath addCurveToPoint:CGPointMake(211+56.5,60.7) controlPoint1:CGPointMake(211+59,59.1) controlPoint2:CGPointMake(211+56.5,60.7)];
    [linePath addCurveToPoint:CGPointMake(211+55.5,64.5) controlPoint1:CGPointMake(211+56.5,60.7) controlPoint2:CGPointMake(211+55.5,64.5)];
    [linePath addCurveToPoint:CGPointMake(211+51.5,65) controlPoint1:CGPointMake(211+55.5,64.5) controlPoint2:CGPointMake(211+51.5,65)];
    

    gearBorderLayer.path=linePath.CGPath;
    gearBorderLayer.strokeColor = [Util colorWithHexString:@"#FFFFFFFF"].CGColor;
    gearBorderLayer.fillColor=[Util colorWithHexString:@"#8dc7c6CC"].CGColor;
    [viewBorder.layer addSublayer:gearBorderLayer];
    
}

-(void) changeToLoginView{
    [btnFb setHidden:YES];
    [btnGoogle setHidden:YES];
    [btnProfile setHidden:NO];
    [btnCollection changeToLogin];
    [btnFavorite changeToLogin];
    [btnGoodsBox changeToLogin];
    [self moveUpOffsetByButton:btnFavorite toTop:138];
    [self moveUpOffsetByButton:btnGoodsBox toTop:184];
    [self moveUpOffsetByButton:btnCollection toTop:231];
    [self moveUpOffsetByButton:btnSuggestion toTop:290];
    [self moveUpOffsetByButton:btnConfig toTop:336.5];
    [self moveUpOffsetByButton:viewEdge toTop:-46.5];
    [self clearBorder];
    [self addLineBorder];
    if([GV getGlobalStatus]!=MENU){
        [self setFrame:CGRectMake(self.frame.origin.x-4, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }
}
-(void)clearBorder{
    viewBorder.layer.sublayers=nil;
}
-(void)addCircleBorder{
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(211+51.5, 0)];
    [linePath addLineToPoint:CGPointMake(211+51.5, 29)];
    [linePath addArcWithCenter:CGPointMake(211+51.5, 48.5) radius:18.5 startAngle:-M_PI/2 endAngle:M_PI/2 clockwise:YES];
    [linePath addLineToPoint:CGPointMake(211+51.5, gv.screenH)];
    borderLayer.path=linePath.CGPath;
    borderLayer.fillColor=[UIColor clearColor].CGColor;
    borderLayer.strokeColor = [Util colorWithHexString:@"#FFFFFFFF"].CGColor;
    [viewBorder.layer addSublayer:borderLayer];
}
-(void)addLineBorder{
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(211+51.5, 0)];
    [linePath addLineToPoint:CGPointMake(211+51.5, gv.screenH)];
    borderLayer.path=linePath.CGPath;
    borderLayer.lineWidth=1;
    borderLayer.strokeColor = [Util colorWithHexString:@"#FFFFFFFF"].CGColor;
    [viewBorder.layer addSublayer:borderLayer];
}

-(void) changeToUnloginView:(BOOL) isIni{
    [btnFb setHidden:NO];
    [btnGoogle setHidden:NO];
    [btnProfile setHidden:YES];
    [btnCollection changeToUnlogin];
    [btnFavorite changeToUnlogin];
    [btnGoodsBox changeToUnlogin];
    if(isIni){
        return;
    }
    
    [self moveUpOffsetByButton:btnFavorite toTop:184.5];
    [self moveUpOffsetByButton:btnGoodsBox toTop:231];
    [self moveUpOffsetByButton:btnCollection toTop:277.5];
    [self moveUpOffsetByButton:btnSuggestion toTop:336.5];
    [self moveUpOffsetByButton:btnConfig toTop:383];
    [self moveUpOffsetByButton:viewEdge toTop:0];
    
    viewBorder.layer.sublayers=nil;
    [self addGearBorder];
}


-(void) moveUpOffsetByButton:(UIView *) tar  toTop:(double) toTop{
    [tar setFrame:CGRectMake(tar.frame.origin.x,toTop,tar.frame.size.width,tar.frame.size.height)];
}
- (UIViewController*)getViewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
