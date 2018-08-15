//
//  BVShopperProfile.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVShopperProfile.h"
#import "BVRecommendedProduct.h"

@implementation BVShopperProfile

- (instancetype)init {

  if ((self = [super init])) {
    self.brands = [NSDictionary dictionary];
    self.interests = [NSDictionary dictionary];
    self.recommendations = [NSArray array];
    self.product_keys = [NSSet set];
  }

  return self;
}

- (id)initWithDictionary:(NSDictionary *)apiResponse {

  if ((self = [super init])) {

    NSDictionary *profile = [apiResponse objectForKey:@"profile"];

    if (profile) {

      self.brands = [profile objectForKey:@"brands"];

      self.interests = [profile objectForKey:@"interests"];

      NSDictionary *recommendationStats =
          [profile objectForKey:@"recommendationStats"];

      NSSet *recommendationProductIds =
          [profile objectForKey:@"recommendations"];

      NSDictionary *products = [profile objectForKey:@"products"];

      NSMutableArray *tmp = [NSMutableArray array];

      if (recommendationProductIds && products) {

        self.product_keys = recommendationProductIds;

        for (NSString *productKey in recommendationProductIds) {

          NSDictionary *product = [products objectForKey:productKey];

          BVRecommendedProduct *bvProduct = [[BVRecommendedProduct alloc]
                   initWithDictionary:product
              withRecommendationStats:recommendationStats];

          if (bvProduct) {
            [tmp addObject:bvProduct];
          }
        }
      }

      self.recommendations = [NSArray arrayWithArray:tmp];
    }
  }

  return self;
}

- (NSString *)description {

  return
      [NSString stringWithFormat:@"BVShopperProfile: Interests:%@\nBrands:%@",
                                 self.interests, self.brands];
}

@end
