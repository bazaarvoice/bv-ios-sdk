//
//  BVBaseReviewsRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseReviewsRequest.h"
#import "BVAnalyticsManager.h"
#import "BVSort.h"
#import "BVCore.h"
#import "BVFilter.h"
#import "BVCommaUtil.h"

@implementation BVBaseReviewsRequest

- (nonnull instancetype)initWithID:(NSString * _Nonnull)ID limit:(int)limit offset:(int)offset {
    if (self = [super init]) {
        [self initDefaultProps:ID];
        _limit = limit;
        _offset = offset;
    }
    return self;
}

- (void)initDefaultProps:(NSString *)ID{
    
    _ID = [BVCommaUtil escape:ID];
    
    _filters = [NSMutableArray array];
    _sorts = [NSMutableArray array];
    _includes = [NSMutableArray array];
    
    // filter the request to the given productId
    BVFilter* filter = [[BVFilter alloc] initWithString:@"ProductId" filterOperator:BVFilterOperatorEqualTo values:@[_ID]];
    [self.filters addObject:filter];
}


- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
    
    for (BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    for (NSString*include in self.includes){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:include]];
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

- (NSString * _Nonnull)endpoint {
    return @"reviews.json";
}

- (nonnull instancetype)search:(NSString * _Nonnull)search {
    // this invalidates sort options
    _search = search;
    return self;
}

- (nonnull instancetype)addInclude:(BVReviewIncludeType)include{
    
    [self.includes addObject:[BVReviewIncludeTypeUtil toString:include]];
    
    if (include == BVReviewIncludeTypeProducts){
        [self addAdditionalField:@"Stats" value:@"Reviews"]; // Always include stats when requesting products with reviews
    }
    
    return self;
}

- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order {
    LOG_DEPRECATED_MESSAGE(@"addSort")
    BVSort* sort = [[BVSort alloc] initWithOption:option order:order];
    [self.sorts addObject:sort];
    return self;
}

- (nonnull instancetype)addReviewSort:(BVSortOptionReviews)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionReviewUtil toString:option] order:order];
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

- (void)load:(void (^ _Nonnull)(id<BVResponse>  _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure {
    if (self.limit < 1 || self.limit > 100) {
        // invalid request
        [self sendError:[super limitError:self.limit] failureCallback:failure];
    }
    else {
        [self loadReviews:self completion:success failure:failure];
    }
}

- (void)loadReviews:(BVConversationsRequest *)request completion:(void (^)(id<BVResponse> _Nonnull))completion failure:(void (^)(NSArray<NSError *> * _Nonnull))failure {
    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {
        id reviewResponse = [self createResponse: response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(reviewResponse);
        });
        [self sendReviewsAnalytics:reviewResponse];
    } failure:failure];
}

-(id<BVResponse>)createResponse:(NSDictionary *)raw {
    NSAssert(true, @"Should be implemented in subclasses");
    return nil;
}

- (void)sendReviewsAnalytics:(BVReviewsResponse*)reviewsResponse {
    
    [self sendReviewResultsAnalytics:reviewsResponse.results];
}

- (void)sendReviewResultsAnalytics:(NSArray<BVReview *>*)reviews{
    
    for (BVReview* review in reviews) {
        
        // Record Review Impression
        NSString *brandName = review.product.brand ? review.product.brand.name : nil;
        BVImpressionEvent *reviewImpression = [[BVImpressionEvent alloc] initWithProductId:review.productId
                                                                             withContentId:review.identifier
                                                                            withCategoryId:review.product.categoryId
                                                                           withProductType:BVPixelProductTypeConversationsReviews
                                                                           withContentType:BVPixelImpressionContentTypeReview
                                                                                 withBrand:brandName withAdditionalParams:nil];
        
        [BVPixel trackEvent:reviewImpression];
        
    }
    // send pageview for product
    BVReview* review = reviews.firstObject;
    if (review != nil) {
        NSNumber* count = @([reviews count]);
        
        NSDictionary *addParams = @{@"numReviews":count};
        NSString *brandName = review.product.brand ? review.product.brand.name : nil;
        BVPageViewEvent *pageView = [[BVPageViewEvent alloc] initWithProductId:review.productId
                                                        withBVPixelProductType:BVPixelProductTypeConversationsReviews
                                                                     withBrand:brandName
                                                                withCategoryId:review.product.categoryId
                                                            withRootCategoryId:nil
                                                          withAdditionalParams:addParams];
        
        [BVPixel trackEvent:pageView];
    }
}
@end
