//
//  BVSubmittedAnswer.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// A successfully submitted answer.
@interface BVSubmittedAnswer : NSObject

@property NSString* _Nullable answerText;
@property bool sendEmailAlertWhenAnswered;
@property NSDate* _Nullable submissionTime;
@property NSNumber* _Nullable typicalHoursToPost;
@property NSString* _Nullable submissionId;
@property NSString* _Nullable answerId;

-(nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end
