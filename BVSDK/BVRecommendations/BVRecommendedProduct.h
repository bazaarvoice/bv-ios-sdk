

//
//  BVProduct.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVRecommendedProduct_h
#define BVRecommendedProduct_h

#import "BVDisplayableProductContent.h"
#import "BVProductReview.h"
#import <Foundation/Foundation.h>

/// Model contents for a single product recommendation display item
@interface BVRecommendedProduct : NSObject <BVDisplayableProductContent>

/**
    A single product recommendation model object

    @param dict The API response object for a product recommendation
    @param recommendationStats The API response object for recommendation
   statistics

    @return A full initialized BVRecommendedProduct model object
  */
- (nonnull id)initWithDictionary:(nonnull NSDictionary *)dict
         withRecommendationStats:(nonnull NSDictionary *)recommendationStats;

/// The unique idenfitier of the product
@property(nonnull, strong, nonatomic) NSString *productId;

/// The product title
@property(nonnull, strong, nonatomic) NSString *productName;

/// The fully qualified URL for this product.
@property(nonnull, strong, nonatomic) NSString *productPageURL;

/// The product image thumbnail. Sizes may vary depending on the brand or client
@property(nonnull, strong, nonatomic) NSString *imageURL;

/// The average (float) rating for this product
@property(nonnull, strong, nonatomic) NSNumber *averageRating;

/// The total number of reviews on the product (integer)
@property(nonnull, strong, nonatomic) NSNumber *numReviews;

/// Price, in USD
@property(nonnull, strong, nonatomic) NSString *price;

/// Highlighted review for this product.
@property(nonnull, strong, nonatomic) BVProductReview *review;

/// Whether this recommendation is a sponsored piece of content or not
@property bool sponsored;

/// Record a tap event -- the user tapped a product
- (void)recordTap;

/// Record an impression event -- the user was shown this product
- (void)recordImpression;

/// Internal use
@property(nonnull, strong, nonatomic) NSDictionary *rawProductDict;

@end

#endif
