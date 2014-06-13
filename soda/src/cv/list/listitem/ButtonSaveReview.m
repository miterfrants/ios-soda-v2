#import "ButtonSaveReview.h"

@implementation ButtonSaveReview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([GV getGlobalStatus]!=LIST_EXPAND){
        return;
    }
    [super touchesBegan:touches withEvent:event];
}
@end
