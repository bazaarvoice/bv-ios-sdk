//
//  BVSubmittedQuestion.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

/// A successfully submitted question.
@interface BVSubmittedQuestion : BVSubmittedType

@property(nullable) NSString *questionSummary;
@property(nullable) NSString *questionDetails;
@property(nullable) NSString *questionId;
@property(nullable) NSString *submissionId;

@property(nullable) NSNumber *sendEmailAlertWhenAnswered;
@property(nullable) NSNumber *sendEmailAlertWhenPublished;
@property(nullable) NSNumber *typicalHoursToPost;

@property(nullable) NSDate *submissionTime;

@end
