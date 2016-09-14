//
//  BVStoreItemsRequest.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVBulkStoreItemsRequest.h"
#import "BVSDKManager.h"
#import "BVFilter.h"
#import "PDPInclude.h"

@interface BVBulkStoreItemsRequest()
    
    @property int limit;
    @property int offset;
    @property NSMutableArray<NSNumber*>* _Nonnull storeContentTypeStatistics;
    @property NSArray<NSString *>* _Nonnull filterStoreIds;

    @end

@implementation BVBulkStoreItemsRequest


- (nonnull instancetype)init:(int)limit offset:(int)offset{
    
    self = [super init];
    if(self){
        
        self.limit = limit;
        self.offset = offset;
        [self initDefaultProps];
        
    }
    return self;
    
}

- (nonnull instancetype)initWithStoreIds:(NSArray * _Nonnull)storeIds{
    
    self = [super init];
    if(self){
        
        self.limit = [storeIds count];
        self.offset = 0;
        [self initDefaultProps];
        _filterStoreIds = storeIds;
        
    }
    return self;
}

- (void)initDefaultProps{
    _filterStoreIds = [NSArray array];
    self.storeContentTypeStatistics = [NSMutableArray array];
}


- (void)load:(void (^ _Nonnull)(BVBulkStoresResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure{
    [super loadStores:self completion:success failure:failure];
}
    
    
- (NSString * _Nonnull)endpoint{
    return @"products.json";
}
   
    
- (NSMutableArray * _Nonnull)createParams{
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];

    [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
    
    if (_storeContentTypeStatistics.count) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:[self statisticsToParams:self.storeContentTypeStatistics]]];
    }
    
    if ([self.filterStoreIds count] > 0){
        BVFilter* filter = [[BVFilter alloc] initWithString:[BVProductFilterTypeUtil toString:BVProductFilterTypeId] filterOperator:BVFilterOperatorEqualTo values:self.filterStoreIds];
        NSString* filterValue = [filter toParameterString];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:filterValue]];
    }
    
    return params;
}
  
    
- (nonnull instancetype)includeStatistics:(BVStoreIncludeContentType)contentType {
    [self.storeContentTypeStatistics addObject:@(contentType)];
    return self;
}

    
-(NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(NSNumber* stat in statistics) {
        [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}


- (NSString *)getPassKey{
    return [BVSDKManager sharedManager].apiKeyConversationsStores;
}
@end
