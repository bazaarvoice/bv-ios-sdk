//
//  BVSubmittedAnswer.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

/// A successfully submitted answer.
@interface BVSubmittedAnswer : BVSubmittedType

@property(nullable) NSString *answerText;
@property bool sendEmailAlertWhenAnswered;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSNumber *typicalHoursToPost;
@property(nullable) NSString *submissionId;
@property(nullable) NSString *answerId;

@end
