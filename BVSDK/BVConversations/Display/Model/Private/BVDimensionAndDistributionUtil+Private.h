//
//  BVDimensionAndDistributionUtil+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVDIMENSIONANDDISTRIBUTIONUTIL_PRIVATE_H
#define BVDIMENSIONANDDISTRIBUTIONUTIL_PRIVATE_H

#import "BVDimensionAndDistributionUtil.h"

@interface BVDimensionAndDistributionUtil : NSObject

+ (nullable TagDistribution)createDistributionWithApiResponse:
    (nullable id)apiResponse;

@end

#endif /* BVDIMENSIONANDDISTRIBUTIONUTIL_PRIVATE_H */
