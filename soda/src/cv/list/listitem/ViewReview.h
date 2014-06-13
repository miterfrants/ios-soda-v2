//
//  ViewReview.h
//  soda
//
//  Created by Po-Hsiang Huang on 2014/5/26.
//  Copyright (c) 2014年 Po-Hsiang Huang. All rights reserved.
//

#import "ViewProtoType.h"
#import "ReviewHeart.h"

@interface ViewReview : ViewProtoType
@property UILabel *lblName;
@property UILabel *lblRating;
@property UILabel *lblComment;
@property UILabel *lblAnnounceDate;
@property CommentSource enCommentSource;
@property UIImageView *imgViewSource;
@property UIView *viewBottomBorder;
@property ReviewHeart *reviewHeart;
@property CGRect originalRect;
@property NSString *sodaMemberId;
@property int unixtime;
-(id)initWithParameter:(CGRect)frame name:(NSString *) name rating:(float)rating comment:(NSString*) comment announceDate:(NSString *) announceDate;
@end
