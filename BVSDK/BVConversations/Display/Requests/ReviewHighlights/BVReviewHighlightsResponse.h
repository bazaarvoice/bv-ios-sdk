//
//  BVReviewHighlightsResponse.h
//  BVSDK
//
//  Copyright © 2020 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVReviewHighlights.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVReviewHighlightsResponse : NSObject

@property(nonnull) BVReviewHighlights *reviewHighlights;

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end

NS_ASSUME_NONNULL_END
