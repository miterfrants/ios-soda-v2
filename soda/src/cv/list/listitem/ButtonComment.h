#import "ButtonSaveReview.h"
#import "ViewVoteHeart.h"
#import "ButtonInputForComment.h"

@interface ButtonComment : ButtonProtoType
@property UIView *viewShapeBg;
@property CAShapeLayer *layerRoundedRectangle;
@property CAShapeLayer *layerTriangle;
@property ViewVoteHeart *voteHeart;
@property UIView *viewBgForFinish;
@property ButtonSaveReview *btnSave;
@property ButtonInputForComment *btnInput;
@property NSString *defaultString;
@property BOOL isExpanded;
@property BOOL isLoaded;
@property CGSize expandedSize;
@property double radius;
@property CGPoint centerForComment;


-(void)contractCommentArea;
-(void)expandCommentArea;
-(CGPathRef)getExpendedRoundedRectangle:(CGSize) expandedSize centerForComment:(CGPoint) centerForComment radius:(double) radius;
-(CGPathRef)getExpandedTriangle:(CGSize) expandedSize centerForComment:(CGPoint) centerForComment radius:(double) radius midOfHeight:(double)midOfHeight;
@end
