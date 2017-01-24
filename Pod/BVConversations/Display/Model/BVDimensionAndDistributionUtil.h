//
//  BVDimensionAndDistributionUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVDistributionElement.h"
#import "BVDimensionElement.h"

typedef NSMutableDictionary<NSString*, BVDistributionElement*>* TagDistribution;
typedef NSMutableDictionary<NSString*, BVDistributionElement*>* ContextDataDistribution;
typedef NSMutableDictionary<NSString*, BVDimensionElement*>* TagDimensions;

/// Internal utility - used only within BVSDK
@interface BVDimensionAndDistributionUtil : NSObject

+(TagDistribution _Nullable)createDistributionWithApiResponse:(id _Nullable)apiResponse;

@end
