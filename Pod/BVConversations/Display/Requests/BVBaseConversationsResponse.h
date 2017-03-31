//
//  BVBaseConversationsResponse.h
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVResponse.h"
#import "BVConversationsInclude.h"

@interface BVBaseConversationsResponse<__covariant ResultType> : NSObject<BVResponse>

@property NSNumber* _Nullable offset;
@property NSString* _Nullable locale;
@property NSNumber* _Nullable totalResults;
@property NSNumber* _Nullable limit;

- (nonnull ResultType)createResult:(NSDictionary * _Nonnull)raw includes:(BVConversationsInclude * _Nullable)includes;

@end

@interface BVBaseConversationsResultResponse<__covariant ResultType>: BVBaseConversationsResponse

@property ResultType _Nullable result;

@end


@interface BVBaseConversationsResultsResponse<__covariant ResultType>: BVBaseConversationsResponse

@property NSArray<ResultType> * _Nonnull results;

@end
