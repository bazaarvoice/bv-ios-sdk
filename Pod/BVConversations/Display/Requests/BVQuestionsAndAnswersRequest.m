//
//  QuestionsAndAnswersRequest.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionsAndAnswersRequest.h"
#import "BVFilter.h"
#import "BVCommaUtil.h"
#import "BVLogger.h"

@interface BVQuestionsAndAnswersRequest()

@property int limit;
@property int offset;
@property NSString* _Nullable search;
@property NSMutableArray<BVFilter*>* _Nonnull filters;
@property NSMutableArray<BVSort*>* _Nonnull sorts;

@end

@implementation BVQuestionsAndAnswersRequest

- (nonnull instancetype)initWithProductId:(NSString * _Nonnull)productId limit:(int)limit offset:(int)offset {
    self = [super init];
    if(self){
        _productId = [BVCommaUtil escape:productId];
        self.limit = (int)limit;
        self.offset = (int)offset;
        
        self.filters = [NSMutableArray array];
        self.sorts = [NSMutableArray array];
        
        // filter the request to the given productId
        BVFilter* filter = [[BVFilter alloc] initWithString:@"ProductId" filterOperator:BVFilterOperatorEqualTo values:@[self.productId]];
        [self.filters addObject:filter];
    }
    return self;
}

- (nonnull instancetype)addSort:(BVSortOptionProducts)option order:(BVSortOrder)order {
    BVSort* sort = [[BVSort alloc] initWithOption:option order:order];
    [self.sorts addObject:sort];
    return self;
}

- (nonnull instancetype)addFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value {
    [self addFilter:type filterOperator:filterOperator values:@[value]];
    return self;
}

- (nonnull instancetype)addFilter:(BVQuestionFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values {
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVQuestionFilterTypeUtil toString:type] filterOperator:filterOperator values:values];
    [self.filters addObject:filter];
    return self;
}

- (nonnull instancetype)search:(NSString * _Nonnull)search {
    self.search = search;
    return self;
}

- (void)load:(void (^ _Nonnull)(BVQuestionsAndAnswersResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure {
    // validate request
    if (self.limit < 1 || self.limit > 20) {
        [self sendError:[super limitError:self.limit] failureCallback:failure];
    }
    else {
        [super loadQuestions:self completion:success failure:failure];
    }
}

- (NSString * _Nonnull)endpoint {
    return @"questions.json";
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:@"Answers"]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Search" value:self.search]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
    [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
    
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

@end
