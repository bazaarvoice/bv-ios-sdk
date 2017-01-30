//
//  ProductDisplayPageRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductDisplayPageRequest.h"
#import "BVCommaUtil.h"
#import "BVFilter.h"
#import "BVProductFilterType.h"
#import "BVFilterOperator.h"

@interface BVProductDisplayPageRequest()

@property NSString* _Nonnull productId;
@property NSMutableArray<PDPInclude*>* includes;
@property NSMutableArray<NSNumber*>* _Nonnull PDPContentTypeStatistics;
@property NSMutableArray<BVSort*>* _Nonnull reviewSorts;
@property NSMutableArray<BVSort*>* _Nonnull questionSorts;
@property NSMutableArray<BVSort*>* _Nonnull answerSorts;

@end

@implementation BVProductDisplayPageRequest

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId {
    self = [super init];
    if(self){
        self.productId = [BVCommaUtil escape:productId];
        self.includes = [NSMutableArray array];
        self.reviewSorts = [NSMutableArray array];
        self.questionSorts = [NSMutableArray array];
        self.answerSorts = [NSMutableArray array];
        self.PDPContentTypeStatistics = [NSMutableArray array];
    }
    return self;
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

- (void)load:(ProductRequestCompletionHandler _Nonnull)success failure:(ConversationsFailureHandler _Nonnull)failure {
    [super loadProducts:self completion:success failure:failure];
}

- (NSString * _Nonnull)endpoint {
    return @"products.json";
}
- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVProductFilterTypeUtil toString:BVProductFilterTypeId] filterOperator:BVFilterOperatorEqualTo values:@[self.productId]];
    NSString* filterValue = [filter toParameterString];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:filterValue]];
    
    if (self.reviewSorts.count > 0){
        [params addObject:[self sortParams:self.reviewSorts withKey:@"Sort_Reviews"]];
    }
    
    if (self.questionSorts.count > 0){
        [params addObject:[self sortParams:self.questionSorts withKey:@"Sort_Questions"]];
    }
    
    if (self.answerSorts.count > 0){
        [params addObject:[self sortParams:self.answerSorts withKey:@"Sort_Answers"]];
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

-(BVStringKeyValuePair* _Nonnull)sortParams:(NSArray<BVSort*>* _Nonnull)sorts withKey:(NSString*)paramKey {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(BVSort* sort in sorts) {
        [strings addObject:[sort toString]];
    }
    
    NSString* combined = [strings componentsJoinedByString:@","];
    
    return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
    
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

@end
