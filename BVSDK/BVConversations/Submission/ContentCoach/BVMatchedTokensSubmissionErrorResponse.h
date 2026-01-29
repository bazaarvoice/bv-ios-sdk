//
//  BVMatchedTokensSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import "BVSubmissionErrorResponse.h"
#import "BVMatchedTokens.h"

@interface BVMatchedTokensSubmissionErrorResponse
    : BVSubmissionErrorResponse <BVMatchedTokens *>

@end
