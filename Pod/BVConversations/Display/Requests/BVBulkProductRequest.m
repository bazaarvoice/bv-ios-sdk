//
//  BVBulkProductRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBulkProductRequest.h"

@interface BVBulkProductRequest()

@property NSMutableArray<BVSort*>* _Nonnull sorts;
@property (nonatomic, strong)NSMutableArray<BVFilter*>* _Nonnull filters;

@end

@implementation BVBulkProductRequest


-(instancetype)init {
    if (self = [super init]) {
        _sorts = [NSMutableArray new];
        _filters = [NSMutableArray new];
    }
    
    return self;
}

- (nonnull instancetype)addProductSort:(BVSortOptionProducts)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionProductsUtil toString:option] order:order];
    [self.sorts addObject:sort];
    return self;
}


-(void)load:(ProductSearchRequestCompletionHandler)success failure:(ConversationsFailureHandler)failure {
    [self loadContent:self completion:^(NSDictionary * _Nonnull response) {
        BVBulkProductResponse* productsResponse = [[BVBulkProductResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            success(productsResponse);
        });
        
    } failure:failure];
}

-(NSMutableArray * _Nonnull)createParams {
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    if ([self.sorts count] > 0) {
        NSMutableArray<NSString*>* sortsAsStrings = [NSMutableArray array];
        for (BVSort* sort in self.sorts) {
            [sortsAsStrings addObject:[sort toString]];
        }
        NSString* allTogetherNow = [sortsAsStrings componentsJoinedByString:@","];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Sort" value:allTogetherNow]];
    }
    
    for(BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    return params;
}

- (nonnull instancetype)addFilter:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value {
    [self addFilter:type filterOperator:filterOperator values:@[value]];
    return self;
}

- (nonnull instancetype)addFilter:(BVProductFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values {
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVProductFilterTypeUtil toString:type] filterOperator:filterOperator values:values];
    [self.filters addObject:filter];
    return self;
}

@end
