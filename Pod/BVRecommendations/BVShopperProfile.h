//
//  BVShopperProfile.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVShopperProfile_h
#define BVShopperProfile_h

#import <Foundation/Foundation.h>
#import "BVProduct.h"

NS_ASSUME_NONNULL_BEGIN

/*!
    Data model for a user's product recommendation profile including:
        - Interests
        - Brands
        - Product Recommendations
 */
@interface BVShopperProfile : NSObject


/**
*  Builds the model based on the JSON API response from the BV recommendations API
*
*  @param apiResponse JSON response from BV recommendations API
*
*  @return The initialzed shopper profile model with product `recommendations`.
*/
- (id)initWithDictionary:(NSDictionary *)apiResponse;

/*!
    Brands the user likes. Dictionary where keys are brands and values are strenght, specified by strings: HIGH | MED | LOW
 */
@property (strong, nonatomic) NSDictionary *brands;

/*!
  Dictionary of user's interests
 */
@property (strong, nonatomic) NSDictionary *interests;

/*!
    Array of BVProduct objects, recommended for the user.
 */
@property (strong, nonatomic) NSArray *recommendations;    // Array of BVProducts

/*!
    Product recommendation keys associated with the recommended BVProduct(s).
 */
@property (strong, nonatomic) NSSet *product_keys;  // Array of keys by product

@end

NS_ASSUME_NONNULL_END

#endif
