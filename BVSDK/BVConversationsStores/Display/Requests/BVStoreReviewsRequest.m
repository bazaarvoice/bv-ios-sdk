//
//  ReviewsRequest.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsRequest.h"
#import "BVCommaUtil.h"
#import "BVFilter.h"
#import "BVLogger.h"
#import "BVProductIncludeType.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager+Private.h"
#import "BVSort.h"
#import "BVStoreIncludeType.h"

@interface BVStoreReviewsRequest ()
@property(nonnull) NSMutableArray<BVStoreIncludeType *> *storeIncludeTypes;
@end

@implementation BVStoreReviewsRequest

- (nonnull instancetype)initWithStoreId:(nonnull NSString *)storeId
                                  limit:(NSUInteger)limit
                                 offset:(NSUInteger)offset {
  if ((self = [super initWithID:storeId limit:limit offset:offset])) {
    _storeIncludeTypes = [NSMutableArray array];
  }
  return self;
}

- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeTypeValue)storeIncludeTypeValue {
  [self.storeIncludeTypes
      addObject:[BVStoreIncludeType
                    includeTypeWithRawValue:storeIncludeTypeValue]];
  return self;
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<BVStoreIncludeType *> *)statistics {
  NSMutableArray *strings = [NSMutableArray array];

  for (BVStoreIncludeType *stat in statistics) {
    [strings addObject:[stat toIncludeTypeParameterString]];
  }

  NSArray<NSString *> *sortedArray = [strings
      sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

  return [sortedArray componentsJoinedByString:@","];
}

- (nonnull NSString *)getPassKey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversationsStores;
}

- (NSString *)storeId {
  return self.ID;
}

- (BVDisplayResponse *)createResponse:(NSDictionary *)raw {
  return [[BVStoreReviewsResponse alloc] initWithApiResponse:raw];
}

@end
