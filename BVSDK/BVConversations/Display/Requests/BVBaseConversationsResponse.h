//
//  BVBaseConversationsResponse.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVConversationsInclude.h"
#import "BVResponse.h"
#import <Foundation/Foundation.h>

@interface BVBaseConversationsResponse <__covariant ResultType> : NSObject<BVResponse>

@property (nullable) NSNumber *offset;
@property(nullable) NSString *locale;
@property(nullable) NSNumber *totalResults;
@property(nullable) NSNumber *limit;

- (nonnull ResultType)createResult:(nonnull NSDictionary *)raw
                          includes:(nullable BVConversationsInclude *)includes;

@end

@interface BVBaseConversationsResultResponse <__covariant ResultType>: BVBaseConversationsResponse

@property (nullable) ResultType result;

@end

@interface BVBaseConversationsResultsResponse <__covariant ResultType>: BVBaseConversationsResponse

@property (nonnull) NSArray<ResultType> *results;

@end
