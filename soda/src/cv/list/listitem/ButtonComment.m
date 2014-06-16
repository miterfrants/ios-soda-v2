#import "ButtonComment.h"
#import "Util.h"
#import "ListItem.h"
#import "ViewReview.h"

@implementation ButtonComment
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewShapeBg=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        self.viewShapeBg.userInteractionEnabled=NO;
        [self iniShape];
        [self addSubview:self.viewShapeBg];
        self.centerForComment=CGPointMake(21.8, 22.3);
        self.expandedSize=CGSizeMake(250, 83);
        self.radius=11.2;
        self.btnSave=[[ButtonSaveReview alloc] initWithFrame:CGRectMake(self.expandedSize.width-38, self.expandedSize.height-19, 44, 44)];
        self.voteHeart=[[ViewVoteHeart alloc]initWithFrame:CGRectMake(6, self.radius, 200,self.expandedSize.height/2)];
        self.viewBgForFinish=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.expandedSize.width+self.radius,self.expandedSize.height+self.radius)];
        self.btnSave.viewBg=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"save.png"]];
        self.btnSave.iconOverNameForProtoType=@"save_over.png";
        self.btnSave.iconNameForProtoType=@"save.png";
        [self.btnSave.viewBg setFrame:CGRectMake(0, 0, 44, 44)];
        [self.btnSave addSubview:self.btnSave.viewBg];
        [self addSubview:self.viewBgForFinish];
        [self addSubview:self.voteHeart];

        [self.voteHeart setAlpha:0.0];
        [self.btnSave setAlpha:0.0f];
        [self.viewBgForFinish setAlpha:0.0f];
        self.viewBgForFinish.userInteractionEnabled=NO;
        [self iniFinishBg:self.expandedSize centerForComment:self.centerForComment radius:self.radius midOfHeight:(double) (self.centerForComment.y-self.radius)+self.expandedSize.height/2];
        self.defaultString=@"Commet for the place.";
        self.btnInput=[[ButtonInputForComment alloc] initWithFrameAndText:CGRectMake(23, 63, 200, 20) text:self.defaultString];
        [self.btnInput setAlpha:0.0f];
        [self.btnInput setHidden:YES];
        [self addSubview: self.btnInput];
        [self addSubview:self.btnSave];
    }
    
    return self;
}
-(void) iniShape{
    self.layerRoundedRectangle = [CAShapeLayer layer];
    self.layerRoundedRectangle.path =[self getContractedRoundedRectangle];
    self.layerRoundedRectangle.fillColor=[Util colorWithHexString:@"FFFFFFFF"].CGColor;
    [self.viewShapeBg.layer addSublayer:self.layerRoundedRectangle];
    

    self.layerTriangle = [CAShapeLayer layer];
    self.layerTriangle.path =[self getContractedTriangle];
    self.layerTriangle.fillColor=[Util colorWithHexString:@"FFFFFFFF"].CGColor;
    [self.viewShapeBg.layer addSublayer:self.layerTriangle];
}


-(CGPathRef)getContractedRoundedRectangle{
    double radius=11.2;
    double circleRate=(double) (-4+4*sqrt(2))/3;
    CGPoint centerForComment=CGPointMake(21.8, 22.3);
    UIBezierPath *pathRoundedRectangle = [UIBezierPath bezierPath];
    [pathRoundedRectangle moveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y)];
    [pathRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y)];
    [pathRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x, centerForComment.y-radius) controlPoint1:CGPointMake(centerForComment.x-radius,centerForComment.y-radius*circleRate) controlPoint2:CGPointMake(centerForComment.x-radius*circleRate, centerForComment.y-radius)];
    [pathRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x, centerForComment.y-radius)];
    [pathRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x+radius, centerForComment.y) controlPoint1:CGPointMake(centerForComment.x+radius*circleRate,centerForComment.y-radius) controlPoint2:CGPointMake(centerForComment.x+radius, centerForComment.y-radius*circleRate)];
    [pathRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x+radius, centerForComment.y)];
    [pathRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x, centerForComment.y+radius) controlPoint1:CGPointMake(centerForComment.x+radius,centerForComment.y+radius*circleRate) controlPoint2:CGPointMake(centerForComment.x+radius*circleRate, centerForComment.y+radius)];
    [pathRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x, centerForComment.y+radius)];
    [pathRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y) controlPoint1:CGPointMake(centerForComment.x-radius*circleRate,centerForComment.y+radius) controlPoint2:CGPointMake(centerForComment.x-radius, centerForComment.y+radius*circleRate)];
    [pathRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y)];
    [pathRoundedRectangle closePath];
    return pathRoundedRectangle.CGPath;
}

-(CGPathRef)getContractedTriangle{
    double radius=11.2;
    CGPoint centerForComment=CGPointMake(21.8, 22.3);
    UIBezierPath *pathTriangle = [UIBezierPath bezierPath];
    [pathTriangle moveToPoint:CGPointMake(centerForComment.x, centerForComment.y+radius)];
    [pathTriangle addLineToPoint:CGPointMake(centerForComment.x-radius-1.2, centerForComment.y+radius-1.1)];
    [pathTriangle addLineToPoint:CGPointMake(centerForComment.x-radius+3, centerForComment.y+radius-5)];
    [pathTriangle closePath];
    return pathTriangle.CGPath;
}
-(CGPathRef)getExpandedTriangle:(CGSize) expandedSize centerForComment:(CGPoint) centerForComment radius:(double) radius midOfHeight:(double)midOfHeight{
    UIBezierPath *pathTriangle = [UIBezierPath bezierPath];

    [pathTriangle moveToPoint:CGPointMake(centerForComment.x-radius+0.5, midOfHeight-6)];
    [pathTriangle addLineToPoint:CGPointMake(centerForComment.x-radius-5, midOfHeight)];
    [pathTriangle addLineToPoint:CGPointMake(centerForComment.x-radius+0.5, midOfHeight+6)];
    [pathTriangle closePath];
    return pathTriangle.CGPath;
}


-(CGPathRef)getExpendedRoundedRectangle:(CGSize) expandedSize centerForComment:(CGPoint) centerForComment radius:(double) radius{
    double height=expandedSize.height;
    double width=expandedSize.width;
    double circleRate=(double) (-4+4*sqrt(2))/3;
    
    UIBezierPath *pathNewRoundedRectangle = [UIBezierPath bezierPath];
    [pathNewRoundedRectangle moveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5)];
    [pathNewRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5)];
    [pathNewRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x-radius+5, centerForComment.y-radius) controlPoint1:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5*circleRate) controlPoint2:CGPointMake(centerForComment.x-radius+5*circleRate, centerForComment.y-radius)];
    [pathNewRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x+width-radius-5, centerForComment.y-radius)];
    
    [pathNewRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x+width-radius, centerForComment.y-radius+5) controlPoint1:CGPointMake(centerForComment.x+width-radius-5*circleRate, centerForComment.y-radius) controlPoint2:CGPointMake(centerForComment.x+width-radius, centerForComment.y-radius+5*circleRate)];
    
    [pathNewRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x+width-radius, centerForComment.y+height-radius-5)];
    
    [pathNewRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x+width-radius-5, centerForComment.y+height-radius) controlPoint1:CGPointMake(centerForComment.x+width-radius, centerForComment.y+height-radius-5*circleRate) controlPoint2:CGPointMake(centerForComment.x+width-radius-5*circleRate, centerForComment.y+height-radius)];
    
    [pathNewRoundedRectangle addLineToPoint:CGPointMake(centerForComment.x-radius+5, centerForComment.y+height-radius)];
    
    [pathNewRoundedRectangle addCurveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y+height-radius-5) controlPoint1:CGPointMake(centerForComment.x-radius+5*circleRate, centerForComment.y+height-radius) controlPoint2:CGPointMake(centerForComment.x-radius, centerForComment.y+height-radius-5*circleRate)];
    [pathNewRoundedRectangle closePath];
    return pathNewRoundedRectangle.CGPath;
}
-(void)switchCommentArea{
    if (self.isExpanded) {
        //[self contractCommentArea];
    }else{
        [self expandCommentArea];
    }
}
-(void) expandCommentArea{
    self.isExpanded=YES;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.expandedSize.width+self.radius, self.expandedSize.height+self.radius)];
    double midOfHeight=(double) (self.centerForComment.y-self.radius)+self.expandedSize.height/2;
    
    //Animate path
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.23f;
    pathAnimation.repeatCount = 1;
    pathAnimation.toValue=(id) [self getExpendedRoundedRectangle:self.expandedSize centerForComment:self.centerForComment radius:self.radius];
    pathAnimation.removedOnCompletion=NO;
    pathAnimation.fillMode=kCAFillModeForwards;
    [self.layerRoundedRectangle addAnimation:pathAnimation forKey:nil];
    

    
    CABasicAnimation *pathAnimationForTriangle = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimationForTriangle.duration = 0.23f;
    pathAnimationForTriangle.repeatCount = 1;
    pathAnimationForTriangle.toValue=(id) [self getExpandedTriangle:self.expandedSize centerForComment:self.centerForComment radius:self.radius midOfHeight:midOfHeight];
    pathAnimationForTriangle.removedOnCompletion=NO;
    pathAnimationForTriangle.fillMode=kCAFillModeForwards;
    [self.layerTriangle addAnimation:pathAnimationForTriangle forKey:nil];
    
    ListItem* item=(ListItem *)self.superview;
    [item.scrollViewDetailReview setContentSize:CGSizeMake(self.gv.screenW, item.scrollViewDetailReview.originalContentHeight+self.expandedSize.height)];
    [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [item.lblIForComment setFrame:CGRectMake(item.lblIForComment.frame.origin.x, 180+midOfHeight-28, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
        NSArray *subviews =item.scrollViewDetailReview.subviews;
        for(int i=0;i<subviews.count;i++){
            if([[subviews objectAtIndex:i] isKindOfClass:[ViewReview class]]){
                ViewReview *review=(ViewReview *)[subviews objectAtIndex:i];
                [review setFrame:CGRectMake(review.originalRect.origin.x, review.originalRect.origin.y+self.expandedSize.height, review.originalRect.size.width, review.originalRect.size.height)];
            }
        }
    } completion:^(BOOL finished) {
        if(finished){
            [self.btnInput setHidden:NO];
            [UIView animateWithDuration:0.23 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.voteHeart setAlpha:1.0f];
                [self.viewBgForFinish setAlpha:1.0f];
                [self.btnSave setAlpha:1.0f];
                [self.btnInput setAlpha:1.0f];
            } completion:^(BOOL finished) {
                if(finished){
                }
             }];
        }
    }];
}
-(void) iniFinishBg:(CGSize) expandedSize centerForComment:(CGPoint) centerForComment radius:(double) radius midOfHeight:(double)midOfHeight{
    double height=expandedSize.height;
    double width=expandedSize.width;
    double circleRate=(double) (-4+4*sqrt(2))/3;
    
    UIBezierPath *pathTop = [UIBezierPath bezierPath];
    [pathTop moveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5)];
    [pathTop addLineToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5)];
    [pathTop addCurveToPoint:CGPointMake(centerForComment.x-radius+5, centerForComment.y-radius) controlPoint1:CGPointMake(centerForComment.x-radius, centerForComment.y-radius+5*circleRate) controlPoint2:CGPointMake(centerForComment.x-radius+5*circleRate, centerForComment.y-radius)];
    [pathTop addLineToPoint:CGPointMake(centerForComment.x+width-radius-5, centerForComment.y-radius)];
    
    [pathTop addCurveToPoint:CGPointMake(centerForComment.x+width-radius, centerForComment.y-radius+5) controlPoint1:CGPointMake(centerForComment.x+width-radius-5*circleRate, centerForComment.y-radius) controlPoint2:CGPointMake(centerForComment.x+width-radius, centerForComment.y-radius+5*circleRate)];
    
    [pathTop addLineToPoint:CGPointMake(centerForComment.x+width-radius, centerForComment.y+height/2-radius-5+6)];
    
    [pathTop addLineToPoint:CGPointMake(centerForComment.x-radius-5, midOfHeight)];
    [pathTop addLineToPoint:CGPointMake(centerForComment.x-radius, midOfHeight-6)];
    [pathTop closePath];
    CAShapeLayer *topLayer = [CAShapeLayer layer];
    topLayer.path =pathTop.CGPath;
    topLayer.fillColor=[Util colorWithHexString:@"#aedbdbFF"].CGColor;
    
    
    
    UIBezierPath *pathBottom = [UIBezierPath bezierPath];
    [pathBottom moveToPoint:CGPointMake(centerForComment.x+width-radius, midOfHeight)];
    [pathBottom addLineToPoint:CGPointMake(centerForComment.x+width-radius, centerForComment.y+expandedSize.height-radius-5)];
    [pathBottom addCurveToPoint:CGPointMake(centerForComment.x+width-radius-5, centerForComment.y+height-radius) controlPoint1:CGPointMake(centerForComment.x+width-radius, centerForComment.y+height-radius-5*circleRate) controlPoint2:CGPointMake(centerForComment.x+width-radius-5*circleRate, centerForComment.y+height-radius)];

    
    [pathBottom addLineToPoint:CGPointMake(centerForComment.x-radius+5, centerForComment.y+height-radius)];
    [pathBottom addCurveToPoint:CGPointMake(centerForComment.x-radius, centerForComment.y+height-radius-5) controlPoint1:CGPointMake(centerForComment.x-radius+5*circleRate, centerForComment.y+height-radius) controlPoint2:CGPointMake(centerForComment.x-radius, centerForComment.y+height-radius-5*circleRate)];
    [pathBottom addLineToPoint:CGPointMake(centerForComment.x-radius, midOfHeight+6)];
    [pathBottom addLineToPoint:CGPointMake(centerForComment.x-radius-5, midOfHeight)];
    [pathBottom closePath];
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.path =pathBottom.CGPath;
    bottomLayer.fillColor=[Util colorWithHexString:@"#8fc9c8ff"].CGColor;
    
    [self.viewBgForFinish.layer addSublayer:topLayer];
    [self.viewBgForFinish.layer addSublayer:bottomLayer];
}


-(void)contractCommentArea{
    self.isExpanded=NO;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, 44, 44)];
    //Animate path
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = 0.18f;
    pathAnimation.repeatCount = 1;
    pathAnimation.toValue=(id) [self getContractedRoundedRectangle];
    pathAnimation.removedOnCompletion=NO;
    pathAnimation.fillMode=kCAFillModeForwards;
    [self.layerRoundedRectangle addAnimation:pathAnimation forKey:nil];

    CABasicAnimation *pathAnimationForTriangle = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimationForTriangle.duration = 0.18f;
    pathAnimationForTriangle.repeatCount = 1;
    pathAnimationForTriangle.toValue=(id) [self getContractedTriangle];
    pathAnimationForTriangle.removedOnCompletion=NO;
    pathAnimationForTriangle.fillMode=kCAFillModeForwards;
    [self.layerTriangle addAnimation:pathAnimationForTriangle forKey:nil];
    ListItem* item=(ListItem *)self.superview.superview;
    [item.scrollViewDetailReview setContentSize:CGSizeMake(self.gv.screenW, item.scrollViewDetailReview.originalContentHeight)];
    [self.viewBgForFinish setAlpha:0.0f];
    [self.voteHeart setAlpha:0.0f];
    [self.btnSave setAlpha:0.0f];
    [self.btnInput setAlpha:0.0f];
    [self.btnInput setHidden:YES];
    [UIView animateWithDuration:0.28 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        [item.lblIForComment setFrame:CGRectMake(item.lblIForComment.frame.origin.x, 180, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
        NSArray *subviews =item.scrollViewDetailReview.subviews;
        for(int i=0;i<subviews.count;i++){
            if([[subviews objectAtIndex:i] isKindOfClass:[ViewReview class]]){
                ViewReview *review=(ViewReview *)[subviews objectAtIndex:i];
                [review setFrame:CGRectMake(review.originalRect.origin.x, review.originalRect.origin.y, review.originalRect.size.width, review.originalRect.size.height)];
            }
        }
    } completion:^(BOOL finished) {
        if(finished){

        }
    }];
}


@end
