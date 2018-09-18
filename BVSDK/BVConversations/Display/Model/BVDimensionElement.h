//
//  DimensionElement.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 A single tag dimension.
 */
@interface BVDimensionElement : NSObject

@property(nullable) NSString *label;
@property(nullable) NSString *identifier;
@property(nullable) NSArray<NSString *> *values;

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
