//
//  BVSubmittedComment.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

@interface BVSubmittedComment : BVSubmittedType

@property(nullable, readonly) NSString *commentText;
@property(nullable, readonly) NSString *title;
@property(readonly) BOOL sendEmailAlertWhenAnswered;
@property(nullable, readonly) NSDate *submissionTime;
@property(nullable, readonly) NSNumber *typicalHoursToPost;
@property(nullable, readonly) NSString *submissionId;
@property(nullable, readonly) NSString *commentId;

@end
