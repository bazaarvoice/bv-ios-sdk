//
//  BVSubmittedFeedback.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BVFeedbackInappropriateResponse : NSObject

- (nullable instancetype)initWithFeedbackResponse:(nullable id)feedbackDict;

@property(nonnull) NSString *authorId;
@property(nonnull) NSString *reasonText;

@end

@interface BVFeedbackHelpfulnessResponse : NSObject

- (nullable instancetype)initWithFeedbackResponse:(nullable id)feedbackDict;

@property(nonnull) NSString *authorId;
@property(nonnull) NSString *vote;

@end

@interface BVSubmittedFeedback : NSObject

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@property(nonnull) BVFeedbackInappropriateResponse *inappropriateResponse;
@property(nonnull) BVFeedbackHelpfulnessResponse *helpfulnessResponse;

@end
