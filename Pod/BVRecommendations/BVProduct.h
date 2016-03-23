//
//  BVProduct.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVProduct_h
#define BVProduct_h

#import <Foundation/Foundation.h>
#import "BVProductReview.h"

NS_ASSUME_NONNULL_BEGIN

/*!
    Model contents for a single product recommendation display item
 */
@interface BVProduct : NSObject

/**
 *  A single product recommendation model object
 *
 *  @param dict The API response object for a product recommendation
 *  @param recommendationStats The API response object for recommendation statistics
 *
 *  @return A full initialized BVProduct model object
 */
- (id)initWithDictionary:(NSDictionary *)dict withRecommendationStats:(NSDictionary*)recommendationStats;

/**
 *  The unique idenfitier of the product
 */
@property (strong, nonatomic) NSString *productId;

/**
 *  The product title
 */
@property (strong, nonatomic) NSString *productName;

/**
 *  The fully qualified URL for this product.
 */
@property (strong, nonatomic) NSString *productPageURL;

/**
 *  The product image thumbnail. Sizes may vary depending on the brand or client
 */
@property (strong, nonatomic) NSString *imageURL;

/**
 *  The average (float) rating for this product
 */
@property (strong, nonatomic) NSNumber *averageRating;

/**
 *  The total number of reviews on the product (integer)
 */
@property (strong, nonatomic) NSNumber *numReviews;

/**
 *  Price, in USD
 */
@property (strong, nonatomic) NSString *price;

/**
 *  Highlighted review for this product.
 */
@property (strong, nonatomic) BVProductReview* review;

/**
 *  Whether this recommendation is a sponsored piece of content or not
 */
@property bool sponsored;

/**
 *  Internal use
 */
@property (strong, nonatomic) NSDictionary* rawProductDict;

/**
 *  Record a tap event happening on this recommendation
 */

-(void)recordTap;

/**
 *  Internal use
 */
-(void)recordImpression;



@end

NS_ASSUME_NONNULL_END

#endif