//
//  BVProductTextSeachRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVProductTextSearchRequest.h"
#import "BVBulkProductResponse.h"
#import "BVConversationsRequest+Private.h"
#import "BVStringKeyValuePair.h"

@interface BVProductTextSearchRequest ()

@property NSString *searchText;

@end

@implementation BVProductTextSearchRequest

- (instancetype)initWithSearchText:(NSString *)searchText {
  if ((self = [super init])) {
    _searchText = searchText;
  }

  return self;
}

- (nonnull NSMutableArray *)createParams {
  NSMutableArray<BVStringKeyValuePair *> *params = [super createParams];
  if (_searchText) {
    [params addObject:[BVStringKeyValuePair pairWithKey:@"search"
                                                  value:_searchText]];
  }

  return params;
}

@end
