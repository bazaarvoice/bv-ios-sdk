//
//  BVBaseProductRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBaseProductRequest.h"

@interface BVBaseProductRequest()

@property (nonatomic, strong, nonnull, readonly) NSMutableArray<BVFilter*>* reviewFilters;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray<BVFilter*>* questionFilters;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray<NSNumber*>* PDPContentTypeStatistics;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray<PDPInclude*>* includes;

@end

@implementation BVBaseProductRequest

-(instancetype)init {
    
    if (self  = [super init]) {
        _includes = [NSMutableArray array];
        _reviewFilters = [NSMutableArray array];
        _questionFilters = [NSMutableArray array];
        _PDPContentTypeStatistics = [NSMutableArray array];
    }
    
    return self;
}

-(NSString* _Nonnull)includesToParams:(NSArray<PDPInclude*>* _Nonnull)includes {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(PDPInclude* include in includes) {
        [strings addObject:[include toParamString]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

-(NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(NSNumber* stat in statistics) {
        [strings addObject:[PDPContentTypeUtil toString:[stat intValue]]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

- (NSString * _Nonnull)endpoint {
    return @"products.json";
}

- (nonnull instancetype)includeContent:(PDPContentType)contentType limit:(int)limit {
    PDPInclude* include = [[PDPInclude alloc] initWithContentType:contentType limit:@(limit)];
    [self.includes addObject:include];
    return self;
}

- (nonnull instancetype)includeStatistics:(PDPContentType)contentType {
    [self.PDPContentTypeStatistics addObject:@(contentType)];
    return self;
}

- (nonnull instancetype)addIncludedReviewsFilter:(BVReviewFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value{
    
    BVFilter* filter = [[BVFilter alloc]
                        initWithString:[BVReviewFilterTypeUtil toString:type]
                        filterOperator:filterOperator values:@[value]];
    
    [self.reviewFilters addObject:filter];
    return self;
}

- (nonnull instancetype)addIncludedQuestionsFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value{
    
    BVFilter* filter = [[BVFilter alloc]
                        initWithString:[BVQuestionFilterTypeUtil toString:type]
                        filterOperator:filterOperator values:@[value]];
    
    [self.questionFilters addObject:filter];
    return self;
    
}

- (NSMutableArray * _Nonnull)createParams {
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    for(BVFilter* filter in self.reviewFilters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter_Reviews" value:[filter toParameterString]]];
    }
    
    for(BVFilter* filter in self.questionFilters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter_Questions" value:[filter toParameterString]]];
    }
    
    if (self.includes.count > 0){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:[self includesToParams:self.includes]]];
    }
    
    if ([self statisticsToParams:self.PDPContentTypeStatistics].length > 0){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:[self statisticsToParams:self.PDPContentTypeStatistics]]];
    }
    
    for (PDPInclude* include in self.includes) {
        if(include.limit != nil) {
            NSString* key = [NSString stringWithFormat:@"Limit_%@", [PDPContentTypeUtil toString:include.type]];
            BVStringKeyValuePair* pair = [BVStringKeyValuePair pairWithKey:key value:[NSString stringWithFormat:@"%@", include.limit]];
            [params addObject:pair];
        }
    }
    
    return params;
}

@end

@interface BVBaseSortableProductRequest()

@property NSMutableArray<BVSort*>* _Nonnull reviewSorts;
@property NSMutableArray<BVSort*>* _Nonnull questionSorts;
@property NSMutableArray<BVSort*>* _Nonnull answerSorts;

@end

@implementation BVBaseProductsRequest

-(void)load:(ProductSearchRequestCompletionHandler)success failure:(ConversationsFailureHandler)failure {
    [self loadContent:self completion:^(NSDictionary * _Nonnull response) {
        BVBulkProductResponse* productsResponse = [[BVBulkProductResponse alloc] initWithApiResponse:response];
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            success(productsResponse);
        });
        
    } failure:failure];
}

@end

@implementation BVBaseSortableProductRequest

-(instancetype)init {
    
    if (self = [super init]) {
        self.reviewSorts = [NSMutableArray array];
        self.questionSorts = [NSMutableArray array];
        self.answerSorts = [NSMutableArray array];
    }
    
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


-(BVStringKeyValuePair* _Nonnull)sortParams:(NSArray<BVSort*>* _Nonnull)sorts withKey:(NSString*)paramKey {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(BVSort* sort in sorts) {
        [strings addObject:[sort toString]];
    }
    
    NSString* combined = [strings componentsJoinedByString:@","];
    
    return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
    
}

- (nonnull instancetype)sortIncludedReviews:(BVSortOptionReviews)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionReviewUtil toString:option] order:order];
    [self.reviewSorts addObject:sort];
    return self;
}

- (nonnull instancetype)sortIncludedQuestions:(BVSortOptionQuestions)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionQuestionsUtil toString:option] order:order];
    [self.questionSorts addObject:sort];
    return self;
}

- (nonnull instancetype)sortIncludedAnswers:(BVSortOptionAnswers)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionAnswersUtil toString:option] order:order];
    [self.answerSorts addObject:sort];
    return self;
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    if (self.reviewSorts.count > 0){
        [params addObject:[self sortParams:self.reviewSorts withKey:@"Sort_Reviews"]];
    }
    
    if (self.questionSorts.count > 0){
        [params addObject:[self sortParams:self.questionSorts withKey:@"Sort_Questions"]];
    }
    
    if (self.answerSorts.count > 0){
        [params addObject:[self sortParams:self.answerSorts withKey:@"Sort_Answers"]];
    }
    
    return params;
}

@end
