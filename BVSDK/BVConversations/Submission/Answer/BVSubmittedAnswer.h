//
//  BVSubmittedAnswer.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

/// A successfully submitted answer.
@interface BVSubmittedAnswer : BVSubmittedType

@property(nullable) NSString *answerText;
@property(nullable) NSNumber *sendEmailAlertWhenAnswered;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSNumber *typicalHoursToPost;
@property(nullable) NSString *submissionId;
@property(nullable) NSString *answerId;

@end
