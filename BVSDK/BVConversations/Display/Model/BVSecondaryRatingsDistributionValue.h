//
//  BVSecondaryRatingsDistributionValue.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

/*
 The value of a secondary rating distribution -- see BVGenericValueDistributionElement.h
 */
@interface BVSecondaryRatingsDistributionValue : NSObject

@property(nonnull) NSNumber *value;
@property(nonnull) NSNumber *count;
@property(nullable) NSString *valueLabel;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
