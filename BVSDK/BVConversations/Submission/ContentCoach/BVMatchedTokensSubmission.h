//
//  BVMatchedTokensSubmission.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
//

#import "BVSubmission.h"
#import "BVMatchedTokens.h"
#import "BVBaseUGCSubmission.h"
#import <Foundation/Foundation.h>

/**
 Class to use to submit review tokens to the Bazaarvoice platform.

 You can use the submission request class to send helpfulness votes or flag
 inappropriate content for reviews, questions, or answers.

 For a description of possible fields see our API documentation at:
 https://developer.bazaarvoice.com/docs/read/conversations_api/reference/latest/feedback/submit

 @availability BVSDK 6.1.0 and later
 */

@interface BVMatchedTokensSubmission : BVBaseUGCSubmission <BVMatchedTokens *>

@property(nonnull) NSString *productId;
@property(nonnull) NSString *reviewText;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                          withReviewText:(nonnull NSString *)reviewText;

- (nonnull instancetype)__unavailable init;

@end
