//
//  ReviewsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsRequest.h"
#import "BVCommaUtil.h"
#import "BVFilter.h"
#import "BVLogger.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"
#import "BVSort.h"
#import "PDPInclude.h"

@interface BVStoreReviewsRequest ()

@property(nonnull) NSMutableArray<NSNumber *> *storeContentTypeStatistics;
@property(nonnull) NSMutableArray<BVSort *> *reviewSorts;

@end

@implementation BVStoreReviewsRequest

- (nonnull instancetype)initWithStoreId:(nonnull NSString *)storeId
                                  limit:(int)limit
                                 offset:(int)offset {
  return self = [super initWithID:storeId limit:limit offset:offset];
}

- (nonnull instancetype)includeStatistics:
    (BVStoreIncludeContentType)contentType {
  [self.storeContentTypeStatistics addObject:@(contentType)];
  return self;
}

- (nonnull NSString *)statisticsToParams:
    (nonnull NSArray<NSNumber *> *)statistics {
  NSMutableArray *strings = [NSMutableArray array];

  for (NSNumber *stat in statistics) {
    [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
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

- (id<BVResponse>)createResponse:(NSDictionary *)raw {
  return [[BVStoreReviewsResponse alloc] initWithApiResponse:raw];
}

@end
