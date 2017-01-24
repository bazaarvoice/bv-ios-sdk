//
//  BVAuthorRequest.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorRequest.h"
#import "BVFilter.h"
#import "BVSort.h"
#import "BVCommaUtil.h"
#import "BVLogger.h"
#import "BVAuthorInclude.h"

@interface BVAuthorRequest ()

@property int limit;
@property int offset;
@property NSString* _Nullable search;
@property NSMutableArray<BVFilter*>* _Nonnull filters;
@property NSMutableArray<NSNumber*>* _Nonnull authorContentTypeStatistics;
@property NSMutableArray<BVAuthorInclude*>* includes;
@property NSMutableArray<BVSort*>* _Nonnull reviewSorts;
@property NSMutableArray<BVSort*>* _Nonnull questionSorts;
@property NSMutableArray<BVSort*>* _Nonnull answerSorts;

@end

@implementation BVAuthorRequest

- (nonnull instancetype)initWithAuthorId:(NSString * _Nonnull)authorId{
    return [self initWithAuthorId:authorId limit:1 offset:0];
}

- (nonnull instancetype)initWithAuthorId:(NSString * _Nonnull)authorId limit:(int)limit offset:(int)offset{
    self = [super init];
    if(self){
        
        self.authorContentTypeStatistics = [NSMutableArray array];
        self.filters = [NSMutableArray array];
        
        self.includes = [NSMutableArray array];
        self.reviewSorts = [NSMutableArray array];
        self.questionSorts = [NSMutableArray array];
        self.answerSorts = [NSMutableArray array];
        
        _authorId = [BVCommaUtil escape:authorId];
        
        self.limit = (int)limit;
        self.offset = (int)offset;
        
        self.filters = [NSMutableArray array];
        
        
        // filter the request to the given productId
        BVFilter* filter = [[BVFilter alloc] initWithString:@"Id" filterOperator:BVFilterOperatorEqualTo values:@[self.authorId]];
        [self.filters addObject:filter];
    }
    return self;
}

- (nonnull instancetype)includeStatistics:(BVAuthorContentType)contentType {
    [self.authorContentTypeStatistics addObject:@(contentType)];
    return self;
}

- (nonnull instancetype)includeContent:(BVAuthorContentType)contentType limit:(int)limit {
    BVAuthorInclude* include = [[BVAuthorInclude alloc] initWithContentType:contentType limit:@(limit)];
    [self.includes addObject:include];
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

- (void)load:(void (^ _Nonnull)(BVAuthorResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure {
    
    if (self.limit < 1 || self.limit > 100) {
        // invalid request
        [self sendError:[super limitError:self.limit] failureCallback:failure];
    }
    else {
        [super loadProfile:self completion:success failure:failure];
    }
    
}

- (NSString * _Nonnull)endpoint {
    return @"authors.json";
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
    
    for(BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    if ([self statisticsToParams:self.authorContentTypeStatistics].length > 0){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Stats" value:[self statisticsToParams:self.authorContentTypeStatistics]]];
    }
    
    if (self.includes.count > 0){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:[self includesToParams:self.includes]]];
    }
    
    for (BVAuthorInclude* include in self.includes) {
        if(include.limit != nil) {
            NSString* key = [NSString stringWithFormat:@"Limit_%@", [BVAuthorContentTypeUtil toString:include.type]];
            BVStringKeyValuePair* pair = [BVStringKeyValuePair pairWithKey:key value:[NSString stringWithFormat:@"%@", include.limit]];
            [params addObject:pair];
        }
    }

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


-(NSString* _Nonnull)includesToParams:(NSArray<BVAuthorInclude*>* _Nonnull)includes {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(BVAuthorInclude* include in includes) {
        [strings addObject:[include toParamString]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

-(NSString* _Nonnull)statisticsToParams:(NSArray<NSNumber*>* _Nonnull)statistics {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(NSNumber* stat in statistics) {
        [strings addObject:[BVAuthorContentTypeUtil toString:[stat intValue]]];
    }
    
    NSArray<NSString*>* sortedArray = [strings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

-(BVStringKeyValuePair* _Nonnull)sortParams:(NSArray<BVSort*>* _Nonnull)sorts withKey:(NSString*)paramKey {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(BVSort* sort in sorts) {
        [strings addObject:[sort toString]];
    }
    
    NSString* combined = [strings componentsJoinedByString:@","];
    
    return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
    
}

@end
