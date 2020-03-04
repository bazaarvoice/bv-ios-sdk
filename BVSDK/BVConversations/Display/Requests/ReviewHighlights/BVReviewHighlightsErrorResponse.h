//
//  BVReviewHighlightsErrorResponse.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVDisplayErrorResponse.h"


@interface BVReviewHighlightsErrorResponse : BVDisplayErrorResponse

- (nonnull NSError *)toNSError;

@end

