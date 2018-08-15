//
//  BVRecommendationsRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationsRequest+Private.h"
#import "BVRecommendationsRequestOptionsUtil.h"

@interface BVRecommendationsRequest ()

@property(nullable, readwrite) NSString *productId;
@property(nullable, readwrite) NSString *categoryId;
@property(readwrite) NSUInteger limit;

@end

@implementation BVRecommendationsRequest

- (void)setPurpose:(BVRecommendationsRequestPurpose)purpose {
  _purposeIsSet = YES;
  _purpose = purpose;
}

- (instancetype)commonInit {
  self.allowInactiveProducts = NO;
  _purpose = BVRecommendationsRequestPurposeAds;
  _purposeIsSet = NO;

  _includes = [NSMutableSet<NSString *> set];
  _interests = [NSMutableSet<NSString *> set];
  _strategies = [NSMutableSet<NSString *> set];

  return self;
}

- (instancetype)initWithLimit:(NSUInteger)limit {
  if ((self = [super init])) {
    self.productId = nil;
    self.categoryId = nil;
    self.limit = limit;
  }
  return [self commonInit];
}

- (instancetype)initWithLimit:(NSUInteger)limit
                withProductId:(NSString *)productId {
  if ((self = [super init])) {
    self.productId = productId;
    self.categoryId = nil;
    self.limit = limit;
  }
  return [self commonInit];
}

- (instancetype)initWithLimit:(NSUInteger)limit
               withCategoryId:(NSString *)categoryId {
  if ((self = [super init])) {
    self.productId = nil;
    self.categoryId = categoryId;
    self.limit = limit;
  }
  return [self commonInit];
}

- (nonnull instancetype)addInclude:(BVRecommendationsRequestInclude)include {
  [self.includes addObject:[BVRecommendationsRequestOptionsUtil
                               valueForRecommendationsRequestInclude:include]
                               .lowercaseString];
  return self;
}

- (nonnull instancetype)addStrategy:(nonnull NSString *)strategy {
  if (!strategy) {
    return self;
  }

  NSString *trimmedStrategy = [strategy
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (0 < trimmedStrategy.length) {
    [self.strategies addObject:trimmedStrategy.lowercaseString];
  }
  return self;
}

@end
