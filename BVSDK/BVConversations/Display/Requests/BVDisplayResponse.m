//
//  BVDisplayResponse.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVDisplayResponse.h"
#import "BVConversationsInclude.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult.h"
#import "BVNullHelper.h"

@implementation BVDisplayResponse

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.limit, apiResponse[@"Limit"])
    SET_IF_NOT_NULL(self.totalResults, apiResponse[@"TotalResults"])
    SET_IF_NOT_NULL(self.locale, apiResponse[@"Locale"])
    SET_IF_NOT_NULL(self.offset, apiResponse[@"Offset"])
  }
  return self;
}

- (BVConversationsInclude *)getIncludes:(NSDictionary *)apiResponse {
  NSDictionary *rawIncludes = apiResponse[@"Includes"];
  BVConversationsInclude *includes =
      [[BVConversationsInclude alloc] initWithApiResponse:rawIncludes];
  return includes;
}

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  NSAssert(NO, @"createResult method should be overridden");
  return nil;
}

@end

@implementation BVDisplayResultResponse

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    NSArray<NSDictionary *> *results = apiResponse[@"Results"];
    if (results.count) {
      _result = [self createResult:results.firstObject
                          includes:[self getIncludes:apiResponse]];
    }
  }
  return self;
}

@end

@implementation BVDisplayResultsResponse

- (id)initWithApiResponse:(NSDictionary *)apiResponse {
  if ((self = [super initWithApiResponse:apiResponse])) {
    NSArray<NSDictionary *> *apiResults = apiResponse[@"Results"];
    BVConversationsInclude *includes = [self getIncludes:apiResponse];
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *result in apiResults) {
      [results addObject:[self createResult:result includes:includes]];
    }

    _results = [NSArray arrayWithArray:results];
  }
  return self;
}

@end
