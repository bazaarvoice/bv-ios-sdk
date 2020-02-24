//
//  BVReviewHighlights.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewHighlight.h"

@interface BVReviewHighlights : NSObject

@property(nullable) NSArray<BVReviewHighlight *> *positives;
@property(nullable) NSArray<BVReviewHighlight *> *negatives;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

