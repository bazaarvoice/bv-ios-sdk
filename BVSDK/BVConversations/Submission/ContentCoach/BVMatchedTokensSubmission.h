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
 */

@interface BVMatchedTokensSubmission : BVBaseUGCSubmission <BVMatchedTokens *>

@property(nonnull) NSString *productId;
@property(nonnull) NSString *reviewText;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                          withReviewText:(nonnull NSString *)reviewText;

- (nonnull instancetype)__unavailable init;

@end
