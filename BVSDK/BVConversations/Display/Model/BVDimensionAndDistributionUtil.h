//
//  BVDimensionAndDistributionUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionElement.h"
#import "BVDistributionElement.h"
#import <Foundation/Foundation.h>

typedef NSMutableDictionary<NSString *, BVDistributionElement *>
    *TagDistribution;
typedef NSMutableDictionary<NSString *, BVDistributionElement *>
    *ContextDataDistribution;
typedef NSMutableDictionary<NSString *, BVDimensionElement *> *TagDimensions;

/// Internal utility - used only within BVSDK
@interface BVDimensionAndDistributionUtil : NSObject

+ (nullable TagDistribution)createDistributionWithApiResponse:
    (nullable id)apiResponse;

@end
