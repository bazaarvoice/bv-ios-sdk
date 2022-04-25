//
//  BVGenericDimensionElement.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import "BVSecondaryRatingsDistributionValue.h"
#import <Foundation/Foundation.h>


@interface BVSecondaryRatingsDistributionElement : NSObject

@property(nonnull) NSString *label;
@property(nonnull) NSString *identifier;
@property(nonnull) NSArray<BVSecondaryRatingsDistributionValue *> *values;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
