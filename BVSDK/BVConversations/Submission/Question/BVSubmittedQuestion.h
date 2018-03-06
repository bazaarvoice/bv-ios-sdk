//
//  BVSubmittedQuestion.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted question.
@interface BVSubmittedQuestion : NSObject

@property(nullable) NSString *questionSummary;
@property(nullable) NSString *questionDetails;
@property(nullable) NSString *questionId;
@property(nullable) NSString *submissionId;

@property(nullable) NSNumber *sendEmailAlertWhenAnswered;
@property(nullable) NSNumber *sendEmailAlertWhenPublished;
@property(nullable) NSNumber *typicalHoursToPost;

@property(nullable) NSDate *submissionTime;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
