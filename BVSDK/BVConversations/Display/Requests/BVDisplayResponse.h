//
//  BVDisplayResponse.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BVGenericConversationsResult;
@interface BVDisplayResponse <
    __covariant GenericType : BVGenericConversationsResult *> : NSObject

@property(nullable) NSNumber *offset;
@property(nullable) NSString *locale;
@property(nullable) NSNumber *totalResults;
@property(nullable) NSNumber *limit;

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end

@interface BVDisplayResultResponse <
    __covariant ResultType : BVGenericConversationsResult *> : BVDisplayResponse<ResultType>

@property (nullable) ResultType result;

@end

@interface BVDisplayResultsResponse <
    __covariant ResultsType : BVGenericConversationsResult *> : BVDisplayResponse<ResultsType>

@property (nonnull) NSArray<ResultsType> *results;

@end
