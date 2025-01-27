//
//  BVSummarisedFeaturesQuotesResponse.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVSummarisedFeaturesQuotesResponse_h
#define BVSummarisedFeaturesQuotesResponse_h

#import "BVProductSentimentsResponse.h"
#import "BVQuotes.h"

@interface BVSummarisedFeaturesQuotesResponse : BVProductSentimentsResponse <BVQuotes *>

//@property (nullable) ResultType result;
//
//- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end

#endif /* BVSummarisedFeaturesQuotesResponse_h */
