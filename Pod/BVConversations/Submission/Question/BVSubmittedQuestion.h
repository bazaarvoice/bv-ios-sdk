//
//  BVSubmittedQuestion.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted question.
@interface BVSubmittedQuestion : NSObject

@property NSString* _Nullable questionSummary;
@property NSString* _Nullable questionDetails;
@property NSString* _Nullable questionId;
@property NSString* _Nullable submissionId;

@property NSNumber* _Nullable sendEmailAlertWhenAnswered;
@property NSNumber* _Nullable sendEmailAlertWhenPublished;
@property NSNumber* _Nullable typicalHoursToPost;

@property NSDate* _Nullable submissionTime;

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
