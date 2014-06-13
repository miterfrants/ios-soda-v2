#import "ViewVoteHeart.h"

@implementation ViewVoteHeart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isVote=NO;
        double paddingLeft=10;
        self.heart1=[[SingleHeart alloc] initWithFrame:CGRectMake(0+paddingLeft, 0, 44, 44)];
        [self addSubview:self.heart1];
        self.heart2=[[SingleHeart alloc] initWithFrame:CGRectMake(35+paddingLeft, 0, 44, 44)];
        [self addSubview:self.heart2];
        self.heart3=[[SingleHeart alloc] initWithFrame:CGRectMake(70+paddingLeft, 0, 44, 44)];
        [self addSubview:self.heart3];
        self.heart4=[[SingleHeart alloc] initWithFrame:CGRectMake(105+paddingLeft, 0, 44, 44)];
        [self addSubview:self.heart4];
        self.heart5=[[SingleHeart alloc] initWithFrame:CGRectMake(140+paddingLeft, 0, 44, 44)];
        [self addSubview:self.heart5];
        self.heart1.userInteractionEnabled=NO;
        self.heart2.userInteractionEnabled=NO;
        self.heart3.userInteractionEnabled=NO;
        self.heart4.userInteractionEnabled=NO;
        self.heart5.userInteractionEnabled=NO;
        
        self.arrHeart=[[NSArray alloc] initWithObjects:self.heart1,self.heart2,self.heart3,self.heart4,self.heart5, nil];

        [self setRate:0.0f];
        
        
    }
    return self;
}

//0~5
-(void) setRate:(double) rate{
    if(rate<0){
        rate=0;
    }
    if(rate>5){
        rate=5;
    }
    self.rating=rate;
    int intger =floor(rate);
    for(int i=0;i<intger;i++){
        SingleHeart *target =(SingleHeart*)[self.arrHeart objectAtIndex:i];
        [target setRate:1.0f];
    }
    if (intger==5){
        return;
    }
    SingleHeart *endFillTarget =(SingleHeart*)[self.arrHeart objectAtIndex:intger];
    [endFillTarget setRate:(rate)-floor(rate)];
    for(int i=4;i>intger;i--){
        SingleHeart *target =(SingleHeart*)[self.arrHeart objectAtIndex:i];
        [target setRate:0.0f];
    }
}
-(double)getRate{
    return self.rating;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches]anyObject];
    self.tapLocation=[touch locationInView:touch.view];
    self.isVote=YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    [self setRate:(double) (location.x*5/self.frame.size.width)];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isVote=NO;
}

@end
