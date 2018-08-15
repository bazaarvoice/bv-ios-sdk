//
//  BVRecommendationsLoader+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVRECOMMENDATIONSLOADER_PRIVATE_H
#define BVRECOMMENDATIONSLOADER_PRIVATE_H

#import "BVRecommendationsLoader.h"

#define BVRECOMMENDATIONSREQUEST_MAX_AVG_RATING 5.0f

@class BVRecommendationsRequest;

@interface BVRecommendationsLoader ()

- (nonnull NSURL *)getURLForRequest:
    (nullable BVRecommendationsRequest *)request;

@end

#endif /* BVRECOMMENDATIONSLOADER_PRIVATE_H */
