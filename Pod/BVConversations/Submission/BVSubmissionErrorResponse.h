//
//  SubmissionErrorResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsError.h"
#import "BVFieldError.h"
#import <Foundation/Foundation.h>

/*
 The submission reached the Bazaarvoice server successfully but ultimately
 failed. This most commonly is caused
 by issues with validation. For example: a review with `reviewText` that is too
 short, or a review that is missing user information.
 */
@interface BVSubmissionErrorResponse : NSObject

@property bool hasErrors;

@property(nonnull) NSArray<BVConversationsError *> *errors;
@property(nonnull) NSArray<BVFieldError *> *fieldErrors;

@property(nullable) NSString *locale;
@property(nullable) NSString *submissionId;
@property(nullable) NSNumber *typicalHoursToPost;
@property(nullable) NSString *authorSubmissionToken;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;
- (nonnull NSArray<NSError *> *)toNSErrors;

@end
