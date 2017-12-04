//
//  BVShopperProfile.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVShopperProfile_h
#define BVShopperProfile_h

#import "BVRecommendedProduct.h"
#import <Foundation/Foundation.h>

/// Data model for a user's shopper profile including: interests, brands, and
/// product recommendations
@interface BVShopperProfile : NSObject

/**
    Builds the model based on the JSON API response from the BV recommendations
   API

    @param apiResponse JSON response from BV recommendations API

    @return The initialzed shopper profile model with product `recommendations`.
*/
- (nonnull id)initWithDictionary:(nonnull NSDictionary *)apiResponse;

/// Brands the user likes. Dictionary where keys are brands and values are
/// strenght, specified by strings: HIGH | MED | LOW
@property(nonnull, strong, nonatomic) NSDictionary *brands;

/// Dictionary of user's interests
@property(nonnull, strong, nonatomic) NSDictionary *interests;

/// Array of BVRecommendedProduct objects, recommended for the user.
@property(nonnull, strong, nonatomic) NSArray *recommendations;

/// Product recommendation keys associated with the recommended
/// BVRecommendedProduct(s).
@property(nonnull, strong, nonatomic)
    NSSet *product_keys; // Array of keys by product

@end

#endif
