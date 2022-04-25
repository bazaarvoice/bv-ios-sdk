//
//  BVDimensionAndDistributionUtil.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionElement.h"
#import "BVDistributionElement.h"
#import "BVSecondaryRatingsDistributionElement.h"
#import <Foundation/Foundation.h>

typedef NSMutableDictionary<NSString *, BVDistributionElement *>
    *TagDistribution;
typedef NSMutableDictionary<NSString *, BVSecondaryRatingsDistributionElement *>
    *SecondaryRatingsDistribution;
typedef NSMutableDictionary<NSString *, BVDistributionElement *>
    *ContextDataDistribution;
typedef NSMutableDictionary<NSString *, BVDimensionElement *> *TagDimensions;
