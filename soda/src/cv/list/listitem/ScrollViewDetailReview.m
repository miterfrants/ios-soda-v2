#import "ScrollViewDetailReview.h"
#import "ListItem.h"
@implementation ScrollViewDetailReview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
    }
    return self;
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    ListItem *item=(ListItem *) self.superview.superview;
    double flyOutRate=1.2;
    if(item.btnComment.isExpanded){
        flyOutRate=5;
    }
    [item.lblIForComment setFrame:CGRectMake(20-scrollView.contentOffset.y*flyOutRate,item.lblIForComment.frame.origin.y, item.lblIForComment.frame.size.width, item.lblIForComment.frame.size.height)];
    [item.btnComment setFrame:CGRectMake(28-scrollView.contentOffset.y*flyOutRate, item.btnComment.frame.origin.y, item.btnComment.frame.size.width, item.btnComment.frame.size.height)];
}

@end
