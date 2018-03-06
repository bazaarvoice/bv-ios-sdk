//
//  BVRecommendationsRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Recommendations can be requested with a limit and optional productId and
   categoryId filtering.

    When filtered to a `productId`, the recommendations will be largely related
   to that product.

    When filtered to a `categoryId`, the recommendations will be limited to
   products in that category.

    `limit` is the maximum number of recommendations to load. Suggested: 20.
   Max: 50.
 */
@interface BVRecommendationsRequest : NSObject

- (instancetype)initWithLimit:(NSUInteger)limit;
- (instancetype)initWithLimit:(NSUInteger)limit
                withProductId:(NSString *)productId;
- (instancetype)initWithLimit:(NSUInteger)limit
               withCategoryId:(NSString *)categoryId;

/// Unavailable - use -initWithLimit: instead
- (instancetype)init
    __attribute__((unavailable("Use -initWithLimit: instead")));

/// Unavailable - use -initWithLimit: instead
- (instancetype) new
    __attribute__((unavailable("Use -initWithLimit: instead")));

/// internal use
@property(readonly) NSString *productId;
@property(readonly) NSString *categoryId;
@property(readonly) NSUInteger limit;

@end
