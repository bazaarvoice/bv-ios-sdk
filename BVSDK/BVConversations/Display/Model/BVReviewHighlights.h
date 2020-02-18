//
//  BVReviewHighlights.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewHighlight.h"

@interface BVReviewHighlights : NSObject

@property(nullable) NSArray<BVReviewHighlight *> *positive;
@property(nullable) NSArray<BVReviewHighlight *> *negative;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

