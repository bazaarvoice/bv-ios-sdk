//
//  ReviewsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreReviewsRequest.h"
#import "BVFilter.h"
#import "BVSort.h"
#import "BVCommaUtil.h"
#import "BVLogger.h"
#import "PDPInclude.h"
#import "BVSDKManager.h"

@interface BVStoreReviewsRequest()

@property int limit;
@property int offset;
@property NSString* _Nullable search;
@property NSMutableArray<NSNumber*>* _Nonnull storeContentTypeStatistics;
@property NSMutableArray<BVFilter*>* _Nonnull filters;
@property NSMutableArray<BVSort*>* _Nonnull sorts;
@property NSMutableArray<BVSort*>* _Nonnull reviewSorts;

@end

@implementation BVStoreReviewsRequest

- (nonnull instancetype)initWithStoreId:(NSString * _Nonnull)storeId limit:(int)limit offset:(int)offset {
    self = [super init];
    if(self){
        
        self.limit = (int)limit;
        self.offset = (int)offset;
        [self initDefaultProps:storeId];
    }
    return self;
}
   
- (void)initDefaultProps:(NSString *)storeId{
    
    _storeId = [BVCommaUtil escape:storeId];
    
    self.filters = [NSMutableArray array];
    self.sorts = [NSMutableArray array];
    
    // filter the request to the given productId
    BVFilter* filter = [[BVFilter alloc] initWithString:@"ProductId" filterOperator:BVFilterOperatorEqualTo values:@[self.storeId]];
    [self.filters addObject:filter];
}
    
- (nonnull instancetype)includeStatistics:(BVStoreIncludeContentType)contentType {
    [self.storeContentTypeStatistics addObject:@(contentType)];
    return self;
}
    
- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOption:option order:order];
    [self.sorts addObject:sort];
    return self;
}

- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value {
    [self addFilter:type filterOperator:filterOperator values:@[value]];
    return self;
}

- (nonnull instancetype)addFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values {
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVReviewFilterTypeUtil toString:type] filterOperator:filterOperator values:values];
    [self.filters addObject:filter];
    return self;
}

- (nonnull instancetype)search:(NSString * _Nonnull)search {
    // this invalidates sort options
    self.search = search;
    return self;
}

- (void)load:(void (^ _Nonnull)(BVStoreReviewsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure {
    
    if (self.limit < 0 || self.limit > 20) {
        // invalid request
        [self sendError:[super limitError:self.limit] failureCallback:failure];
    }
    else {
        [super loadStoreReviews:self completion:success failure:failure];
    }
    
}

- (NSString * _Nonnull)endpoint {
    return @"reviews.json";
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
    
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value: @"Products"]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:@"Reviews"]];
    
    for(BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    if ([self.sorts count] > 0) {
        NSMutableArray<NSString*>* sortsAsStrings = [NSMutableArray array];
        for (BVSort* sort in self.sorts) {
            [sortsAsStrings addObject:[sort toString]];
        }
        NSString* allTogetherNow = [sortsAsStrings componentsJoinedByString:@","];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Sort" value:allTogetherNow]];
    }

    return params;
    
}

-(NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(NSNumber* stat in statistics) {
        [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

- (NSString * _Nonnull)getPassKey{
    return [BVSDKManager sharedManager].apiKeyConversationsStores;
}


@end
