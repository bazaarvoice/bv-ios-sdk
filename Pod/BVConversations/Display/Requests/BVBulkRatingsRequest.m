//
//  BVBulkRatingsRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBulkRatingsRequest.h"
#import "BVFilter.h"
#import "BVCommaUtil.h"
#import "BVLogger.h"

@interface BVBulkRatingsRequest()

@property NSArray<NSString*>* _Nonnull productIds;
@property BulkRatingsStatsType statistics;
@property NSMutableArray<BVFilter*>* _Nonnull filters;

@end

@implementation BVBulkRatingsRequest

- (NSString * _Nonnull)endpoint {
    return @"statistics.json";
}

- (nonnull instancetype)initWithProductIds:(NSArray<NSString *> * _Nonnull)productIds statistics:(enum BulkRatingsStatsType)statistics {
    self = [super init];
    if(self){
        
        self.productIds = [BVCommaUtil escapeMultiple:productIds];
        self.statistics = statistics;
        
        self.filters = [NSMutableArray array];
        BVFilter* filter = [[BVFilter alloc] initWithString:@"ProductId" filterOperator:BVFilterOperatorEqualTo values:productIds];
        [self.filters addObject:filter];
        
    }
    return self;
}

- (void)load:(void (^ _Nonnull)(BVBulkRatingsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure {
    
    if([self.productIds count] > 50) {
        // invalid request
        [self sendError:[self tooManyProductsError:self.productIds] failureCallback:failure];
    }
    else {
        [self loadBulkRatings:self completion:success failure:failure];
    }
    
}

- (nonnull instancetype)addFilter:(BVBulkRatingsFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values {
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVBulkRatingsFilterTypeUtil toString:type] filterOperator:filterOperator values:values];
    [self.filters addObject:filter];
    return self;
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:[self statsToString:self.statistics]]];
    
    for(BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    return params;
    
}

-(NSString* _Nonnull)statsToString:(BulkRatingsStatsType)stats {
    switch (stats) {
        case BulkRatingsStatsTypeReviews: return @"Reviews";
        case BulkRatingsStatsTypeNativeReviews: return @"NativeReviews";
        case BulkRatingsStatsTypeAll: return @"Reviews,NativeReviews";
    }
}

@end
