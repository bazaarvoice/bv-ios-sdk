//
//  BVMatchedTokensSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import "BVSubmissionResponse.h"
#import "BVMatchedTokens.h"

@interface BVMatchedTokensSubmissionResponse
    : BVSubmissionResponse <BVMatchedTokens *>
@end
