//
//  BVSummarisedFeaturesResponse.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#ifndef BVSummarisedFeaturesResponse_h
#define BVSummarisedFeaturesResponse_h

#import "BVProductSentimentsResponse.h"
#import "BVSummarisedFeatures.h"

@interface BVSummarisedFeaturesResponse : BVProductSentimentsResponse <BVSummarisedFeatures *>

//@property (nullable) ResultType result;
//
//- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end

#endif /* BVSummarisedFeaturesResponse_h */
