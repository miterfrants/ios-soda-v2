

#import <UIKit/UIKit.h>
#import "GV.h"
#import "ButtonProtoType.h"
@interface ButtonIcon : ButtonProtoType
@property NSString *name;
@property UIImageView *imgViewIcon;
@property GV *gv;
- (id)initWithFrame:(CGRect)frame imgFileName:(NSString*) pImgFileName;
-(void) toSelectedStatus;
-(void) toUnSelectedStatus;
@end
