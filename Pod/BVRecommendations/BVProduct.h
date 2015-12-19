//
//  BVProduct.h
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#ifndef BVProduct_h
#define BVProduct_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
    Model contents for a single product recommendation display item
 */
@interface BVProduct : NSObject

/**
 *  A single product recommendation model object
 *
 *  @param dict  The recommendations API response for a single product
 *  @param key   The recommendation key used to uniquely identify the product
 *  @param stats Internal stats, may be nil
 *
 *  @return A full initialized BVProduct model object
 */
- (id)initWithDictionary:(NSDictionary *)dict withProductKey:(NSString *)key withRecStats:(NSDictionary *)stats;

/**
 *  Unique idendifier combining the client and product Id
 */
@property (strong, nonatomic, nonnull) NSString *product_key;  // <client>/<product_id>

/**
 *  The client on behalf the request was created
 */
@property (strong, nonatomic) NSString *client;
/**
 *  The unique idenfitier of the product
 */
@property (strong, nonatomic) NSString *product_id;
/**
 *  The product description summary
 */
@property (strong, nonatomic) NSString *product_description;
/**
 *  The product image thumbnail. Sizes may vary depending on the brand or client
 */
@property (strong, nonatomic) NSString *image_url;
/**
 *  The product title
 */
@property (strong, nonatomic) NSString *name;
/**
 *  The unique ID for the client
 */
@property (strong, nonatomic) NSString *client_id;
/**
 *  The fully qualified URL for this product.
 */
@property (strong, nonatomic) NSString *product_page_url;

/**
 *  The average (float) rating for this product
 */
@property (strong, nonatomic) NSNumber *avg_rating;
/**
 *  The total number of reviews on the product (integer)
 */
@property (strong, nonatomic) NSNumber *num_reviews;

/**
 *  Price, in USD
 */
@property (strong, nonatomic) NSString *price;
/**
 *  Highlighted review for this product
 */
@property (strong, nonatomic) NSString *reviewText;
/**
 *  Title the customer gave on the review of this product.
 */
@property (strong, nonatomic) NSString *reviewTitle;
/**
 *  The author's name for the review highlight
 */
@property (strong, nonatomic) NSString *reviewAuthor;
/**
 *  The city and/or state where the review resides
 */
@property (strong, nonatomic) NSString *reviewAuthorLocation;

@property (strong, nonatomic) NSNumber *sponsored;

// Internal properties
/**
 *  Internal only!
 */
@property (strong, nonatomic) NSNumber *RKB;
/**
 *  Internal only!
 */
@property (strong, nonatomic) NSNumber *RKI;
/**
 *  Internal only!
 */
@property (strong, nonatomic) NSNumber *RKP;
/**
 *  Internal only!
 */
@property (strong, nonatomic) NSString *RS;

@end

NS_ASSUME_NONNULL_END

#endif