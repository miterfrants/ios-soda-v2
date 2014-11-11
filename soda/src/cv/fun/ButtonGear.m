//
//  ButtonGear.m
//  soda
//
//  Created by Po-Hsiang Huang on 2014/4/20.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ButtonGear.h"
#import "Util.h"

@implementation ButtonGear
@synthesize viewBg,gv,viewBorder,viewShadow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewShadow=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:viewShadow];
        
        UIImage *bg=[UIImage imageNamed:@"gear.png"];
        viewBg= [[UIImageView alloc] init];
        [viewBg setImage:bg];
        [viewBg setFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:viewBg];
        viewBorder=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:viewBorder];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([GV getGlobalStatus]==COMMON){
        if([GV getLoginStatus]==LOGINED){
            [self changeDarkBorder];
        }else{
            UIImage *bg=[UIImage imageNamed:@"gear_over.png"];
            [viewBg setImage:bg];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.isCanceled){
        return;
    }
    [self.highlightTimer invalidate];
    self.highlightTimer=nil;
    self.highlightTimer=[NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector:@selector(toUnHighLightStatus) userInfo:nil repeats:NO];
    [super touchesCancelled:touches withEvent:event];
}


-(void)toUnHighLightStatus{
    if([GV getLoginStatus]==LOGINED){
        [self changeLightBorder];
    }else{
        UIImage *bg=[UIImage imageNamed:@"gear.png"];
        [viewBg setImage:bg];
    }
}
-(void)changeDarkBorder{
    viewBorder.layer.sublayers=nil;
    [viewBorder.layer addSublayer:[self getCircleBorderShape:[Util colorWithHexString:@"#263439FF"].CGColor]];
}
-(void)changeLightBorder{
    viewBorder.layer.sublayers=nil;
    [viewBorder.layer addSublayer:[self getCircleBorderShape:[UIColor whiteColor].CGColor]];
}

-(CAShapeLayer*)getCircleBorderShape:(CGColorRef)color{
    CAShapeLayer *circleShape=[CAShapeLayer layer];
    UIBezierPath *circleBorderPath=[UIBezierPath bezierPath];
    [circleBorderPath addArcWithCenter:CGPointMake(22, 22) radius:18.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circleShape.strokeColor= color;
    circleShape.lineWidth=1.5f;
    circleShape.fillColor=[UIColor clearColor].CGColor;
    circleShape.path=circleBorderPath.CGPath;
    return circleShape;
}

-(void)changeToLoginView{
    [viewBg setImage:gv.imgProfile];
    [viewBg setFrame:CGRectMake(3.5, 3.5, 37, 37)];
    
    CAShapeLayer *circleMask=[CAShapeLayer layer];
    UIBezierPath *circlePath=[UIBezierPath bezierPath];
    [circlePath addArcWithCenter:CGPointMake(19, 19) radius:19 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circleMask.path=circlePath.CGPath;
    
    viewShadow.layer.shadowOffset = CGSizeMake(3.2f,3.2f);
    viewShadow.layer.shadowRadius = 1.0f;
    viewShadow.layer.shadowOpacity = 0.7f;
    viewShadow.layer.shadowColor = [Util colorWithHexString:@"#000000ff"].CGColor
    ;
    viewShadow.layer.shadowPath=circlePath.CGPath;
    //[viewBorder setHidden:YES];
    [viewBg.layer setMask:circleMask];
    [self changeLightBorder];
}
-(void)changeToUnloginView{
    UIImage *bg=[UIImage imageNamed:@"gear.png"];
    [viewBg setImage:bg];
    [viewBg setFrame:CGRectMake(0, 0, 44, 44)];
    [self.layer setMask:nil];
    viewBorder.layer.sublayers=nil;
    
    viewShadow.layer.shadowPath=nil;

}


@end
