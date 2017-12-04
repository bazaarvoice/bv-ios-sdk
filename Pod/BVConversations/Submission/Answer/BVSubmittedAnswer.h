//
//  BVSubmittedAnswer.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted answer.
@interface BVSubmittedAnswer : NSObject

@property(nullable) NSString *answerText;
@property bool sendEmailAlertWhenAnswered;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSNumber *typicalHoursToPost;
@property(nullable) NSString *submissionId;
@property(nullable) NSString *answerId;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
