//
//  BVRecommendedProduct.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVNullHelper.h"
#import "BVProductReview+Private.h"
#import "BVRecommendedProduct+Private.h"
#import "BVRecsAnalyticsHelper.h"

@interface BVRecommendedProduct ()

@property BOOL hasSentImpressionEvent;

@end

@implementation BVRecommendedProduct
@synthesize identifier;
@synthesize displayImageUrl;
@synthesize displayName;

- (id)initWithDictionary:(NSDictionary *)dict
    withRecommendationStats:(NSDictionary *)recommendationStats {

  self = [super init];

  NSMutableDictionary *combinedDictionary =
      [NSMutableDictionary dictionaryWithDictionary:dict];
  [combinedDictionary addEntriesFromDictionary:recommendationStats];
  self.rawProductDict = combinedDictionary;

  SET_IF_NOT_NULL(self.productName, [dict objectForKey:@"name"]);
  SET_IF_NOT_NULL(self.productId, [dict objectForKey:@"product"]);
  SET_IF_NOT_NULL(self.productPageURL, [dict objectForKey:@"product_page_url"]);
  SET_IF_NOT_NULL(self.imageURL, [dict objectForKey:@"image_url"]);
  SET_IF_NOT_NULL(self.averageRating, [dict objectForKey:@"avg_rating"]);
  SET_IF_NOT_NULL(self.numReviews, [dict objectForKey:@"num_reviews"]);
  SET_IF_NOT_NULL(self.price, [dict objectForKey:@"price"]);

  self.review =
      [[BVProductReview alloc] initWithDict:[dict objectForKey:@"review"]];

  self.sponsored = [NSNumber numberWithBool:NO];
  if ([dict objectForKey:@"sponsored"] &&
      [[dict objectForKey:@"sponsored"] integerValue] == 1) {
    self.sponsored = [NSNumber numberWithBool:YES];
  }

  return self;
}

- (void)recordTap {

  [BVRecsAnalyticsHelper queueAnalyticsEventForProductTapped:self];
}

- (NSString *)description {

  return [NSString stringWithFormat:@"BVProduct: %@ - id: %@", self.productName,
                                    self.productId];
}

- (NSString *)identifier {
  return _productId;
}

- (NSString *)displayName {
  return _productName;
}

- (NSString *)displayImageUrl {
  return _imageURL;
}

@end
