//
//  BVSubmittedFeedback.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

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

@interface BVSubmittedFeedback : BVSubmittedType

@property(nonnull) BVFeedbackInappropriateResponse *inappropriateResponse;
@property(nonnull) BVFeedbackHelpfulnessResponse *helpfulnessResponse;

@end
