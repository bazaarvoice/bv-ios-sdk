//
//  BVProductFeaturesResponse.h
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#ifndef BVProductFeaturesResponse_h
#define BVProductFeaturesResponse_h

#import "BVProductSentimentsResponse.h"
#import "BVProductFeatures.h"

@interface BVProductFeaturesResponse : BVProductSentimentsResponse <BVProductFeatures *>
@end

#endif /* BVProductFeaturesResponse_h */
