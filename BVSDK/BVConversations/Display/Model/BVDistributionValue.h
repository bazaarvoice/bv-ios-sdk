//
//  DistributionValue.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 The value of a tag distribution -- see BVDistributionElement.h
 */
@interface BVDistributionValue : NSObject

@property(nonnull) NSString *value;
@property(nonnull) NSNumber *count;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
