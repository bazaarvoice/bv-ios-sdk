//
//  DistributionElement.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDistributionValue.h"
#import <Foundation/Foundation.h>

/*
 A single tag distribition.
 */
@interface BVDistributionElement : NSObject

@property(nonnull) NSString *label;
@property(nonnull) NSString *identifier;
@property(nonnull) NSArray<BVDistributionValue *> *values;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
