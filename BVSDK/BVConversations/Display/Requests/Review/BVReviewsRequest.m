//
//  ReviewsRequest.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewsRequest.h"
#import "BVCommaUtil.h"
#import "BVCommon.h"
#import "BVFilter.h"
#import "BVSort.h"
#import "BVStringKeyValuePair.h"

@interface BVReviewsRequest ()

@property BOOL secondaryRatingStats;
@property BOOL tagStats;
@property(nullable) NSString *feature;

@end

@implementation BVReviewsRequest

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                                    limit:(NSUInteger)limit
                                   offset:(NSUInteger)offset {
    self.incentivizedStats = NO;
    self.secondaryRatingStats = NO;
    self.tagStats = NO;
    return self = [super initWithID:productId limit:limit offset:offset primaryFilter: BVReviewFilterValueProductId];
}

- (nonnull instancetype)initWithId:(nonnull NSString *)Id
                         andFilter:(BVReviewFilterValue)filter
                             limit:(NSUInteger)limit
                            offset:(NSUInteger)offset {
    self.incentivizedStats = NO;
    self.secondaryRatingStats = NO;
    self.tagStats = NO;
    return self = [super initWithID:Id limit:limit offset:offset primaryFilter: filter];
}

- (nonnull instancetype)secondaryRatingStats:(BOOL)secondaryRatingStats {
  _secondaryRatingStats = secondaryRatingStats;
   return self;
}

- (nonnull instancetype)tagStats:(BOOL)tagStats {
  _tagStats = tagStats;
  return self;
}

- (nonnull instancetype)feature:(nullable NSString *)feature{
    _feature = feature;
    return self;
}


- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  
  if (self.incentivizedStats == YES) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"incentivizedstats" value:@"true"]];
  }
    
  if (self.secondaryRatingStats == YES) {
      [params addObject:[BVStringKeyValuePair pairWithKey:@"secondaryratingstats" value:@"true"]];
  }

  if (self.tagStats == YES) {
      [params addObject:[BVStringKeyValuePair pairWithKey:@"tagstats" value:@"true"]];
  }
  
  if (self.feature) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"feature" value:self.feature]];
  }

  return params;
}

- (NSString *)productId {
  return self.ID;
}

- (BVDisplayResponse *)createResponse:(NSDictionary *)raw {
  return [[BVReviewsResponse alloc] initWithApiResponse:raw];
}

@end
