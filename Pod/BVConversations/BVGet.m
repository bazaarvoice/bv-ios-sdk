//
//  BVGet.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//


#import "BVGet.h"
#import "BVSettings.h"
#import "BVConstants.h"
#import "BVNetwork.h"

@interface BVGet()

@property BVNetwork *network;

@end

@implementation BVGet

- (id)init{
    return [self initWithType:BVGetTypeReviews];
}

- (id)initWithType:(BVGetType)type {
    self = [super init];
    if (self) {
        
        self.type = type;

        BVNetwork *network = [[BVNetwork alloc] initWithSender:self];
        self.network = network;
        
        // Standard params
        BVSDKManager *sdkManager = [BVSDKManager sharedManager];
        
        // Make sure you set up your own passKey and clientId!
        assert(sdkManager.apiKeyConversations != nil);
        assert(sdkManager.clientId != nil);
        
        [self.network setUrlParameterWithName:@"ApiVersion" value:BV_API_VERSION];
        [self.network setUrlParameterWithName:@"PassKey" value:sdkManager.apiKeyConversations];
    }
    return self;
}

- (void)setDelegate:(id<BVDelegate>)delegate {
    self.network.delegate = delegate;
}

- (id<BVDelegate>)delegate {
    return self.network.delegate;
}

- (void) sendRequestWithDelegate:(id<BVDelegate>)delegate {
    [self setDelegate:delegate];
    [self send];
}

- (void) send {
    [self.network sendGetWithEndpoint:[self getTypeString]];
}

#pragma mark - Set request parameters

- (void)setGenericParameterWithName:(NSString *)name value:(NSString *)value {
    [self.network setUrlParameterWithName:name value:value];
}

- (void)setSearch:(NSString *)search {
    _search = search;
    [self.network setUrlParameterWithName:@"Search" value:search];
}

- (void)setLocale:(NSString *)locale {
    _locale = locale;
    [self.network setUrlParameterWithName:@"Locale" value:locale];
}

- (void)setLimit:(int)limit{
    _limit = limit;
    [self.network setUrlParameterWithName:@"Limit" value:[NSString stringWithFormat:@"%d", limit]];
}

- (void)setOffset:(int)offset{
    _offset = offset;
    [self.network setUrlParameterWithName:@"Offset" value:[NSString stringWithFormat:@"%d", offset]];
}

- (void)setExcludeFamily:(bool)excludeFamily{
    _excludeFamily = excludeFamily;
    [self.network setUrlParameterWithName:@"ExcludeFamily" value:excludeFamily ? @"true" : @"false"];
}

- (void)addInclude:(BVIncludeType)includeType {
    [self.network setUrlListParameterWithName:@"Include" value:[self getIncludeTypeString:includeType]];
}


- (void)addAttribute:(NSString *)attribute {
    [self.network setUrlListParameterWithName:@"Attributes" value:attribute];
}

- (void)addSortForAttribute:(NSString *)attribute ascending:(BOOL)ascending {
    [self.network setUrlListParameterWithName:@"Sort" value:[NSString stringWithFormat:@"%@:%@", attribute, ascending ? @"asc" : @"desc"]];
}

- (void)addStatsOn:(BVIncludeStatsType)type {
    [self.network setUrlListParameterWithName:@"Stats" value:[self getIncludeStatsTypeString:type]];
}

- (void)setSearchOnIncludedType:(BVIncludeType)type search:(NSString *)search {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"Search_%@", [self getIncludeTypeString:type]] value:search];
}

- (void)addSortOnIncludedType:(BVIncludeType)type attribute:(NSString *)attribute ascending:(BOOL)ascending {
    [self.network setUrlListParameterWithName:[NSString stringWithFormat:@"Sort_%@", [self getIncludeTypeString:type]]
                            value:[NSString stringWithFormat:@"%@:%@", attribute, ascending ? @"asc" : @"desc"]];
}

- (void)setLimitOnIncludedType:(BVIncludeType)type value:(int)value {
    [self.network setUrlParameterWithName:[NSString stringWithFormat:@"Limit_%@", [self getIncludeTypeString:type]]
                            value:[NSString stringWithFormat:@"%d", value]];
}

#pragma mark - Filter parameters


- (void)setFilterForAttribute:(NSString *)attribute equality:(BVEquality)equality value:(NSString *)value {
    if(![value isKindOfClass:[NSString class]]){
        NSException *exception = [NSException exceptionWithName: @"InvalidArgumentException"
                                                         reason: @"Value must be of kind NString *"
                                                       userInfo: nil];
        @throw exception;
    }
    [self.network addUrlParameterWithName:@"Filter" value:[NSString stringWithFormat:@"%@:%@:%@",
                                                   attribute,
                                                   [self getEqualityString:equality],
                                                   value]];
}

- (void)setFilterForAttribute:(NSString *)attribute equality:(BVEquality)equality values:(NSArray *)values {
    if(![values isKindOfClass:[NSArray class]]){
        NSException *exception = [NSException exceptionWithName: @"InvalidArgumentException"
                                                         reason: @"Values must be of kind NSArray *"
                                                       userInfo: nil];
        @throw exception;
    }
    [self.network addUrlParameterWithName:@"Filter" value:[NSString stringWithFormat:@"%@:%@:%@",
                                                   attribute,
                                                   [self getEqualityString:equality],
                                                   [values componentsJoinedByString:@","]]];
}

- (void)setFilterOnIncludedType:(BVIncludeType)type
                   forAttribute:(NSString *)attribute
                       equality:(BVEquality)equality
                          value:(NSString *)value {
    if(![value isKindOfClass:[NSString class]]){
        NSException *exception = [NSException exceptionWithName: @"InvalidArgumentException"
                                                         reason: @"Value must be of kind NString *"
                                                       userInfo: nil];
        @throw exception;
    }
    [self.network addUrlParameterWithName:[NSString stringWithFormat:@"Filter_%@", [self getIncludeTypeString:type]]
                            value:[NSString stringWithFormat:@"%@:%@:%@",
                                                   attribute,
                                                   [self getEqualityString:equality],
                                                   value]];
}

- (void)setFilterOnIncludedType:(BVIncludeType)type
                   forAttribute:(NSString *)attribute
                       equality:(BVEquality)equality
                          values:(NSArray *)values {
    if(![values isKindOfClass:[NSArray class]]){
        NSException *exception = [NSException exceptionWithName: @"InvalidArgumentException"
                                                         reason: @"Values must be of kind NSArray *"
                                                       userInfo: nil];
        @throw exception;
    }
    [self.network addUrlParameterWithName:[NSString stringWithFormat:@"Filter_%@", [self getIncludeTypeString:type]]
                            value:[NSString stringWithFormat:@"%@:%@:%@",
                                   attribute,
                                   [self getEqualityString:equality],
                                   [values componentsJoinedByString:@","]]];
}

#pragma mark - helper methods

- (NSString *)getTypeString {
    switch (self.type) {
        case BVGetTypeAnswers:
            return @"answers.json";
        case BVGetTypeAuthors:
            return @"authors.json";
        case BVGetTypeCategories:
            return @"categories.json";
        case BVGetTypeReviewCommments:
            return @"reviewcomments.json";
        case BVGetTypeStoryCommments:
            return @"storycomments.json";
        case BVGetTypeProducts:
            return @"products.json";
        case BVGetTypeQuestions:
            return @"questions.json";
        case BVGetTypeReviews:
            return @"reviews.json";
        case BVGetTypeStatistics:
            return @"statistics.json";
        case BVGetTypeStories:
            return @"stories.json";
    }
    
    return nil;
}

- (NSString *)getIncludeTypeString:(BVIncludeType)includeType {
    switch (includeType) {
        case BVIncludeTypeAnswers:
            return @"Answers";
        case BVIncludeTypeAuthors:
            return @"Authors";
        case BVIncludeTypeCategories:
            return @"Categories";
        case BVIncludeTypeComments:
            return @"Comments";
        case BVIncludeTypeProducts:
            return @"Products";
        case BVIncludeTypeQuestions:
            return @"Questions";
        case BVIncludeTypeReviews:
            return @"Reviews";
        case BVIncludeTypeStories:
            return @"Stories";
    }
}

- (NSString *)getIncludeStatsTypeString:(BVIncludeStatsType)includeStatsType {
    switch (includeStatsType) {
        case BVIncludeStatsTypeAnswers:
            return @"Answers";
        case BVIncludeStatsTypeQuestions:
            return @"Questions";
        case BVIncludeStatsTypeReviews:
            return @"Reviews";
        case BVIncludeStatsTypeNativeReviews:
            return @"NativeReviews";
        case BVIncludeStatsTypeStories:
            return @"Stories";
    }
}

- (NSString *)getEqualityString:(BVEquality)equality {
    switch (equality) {
        case BVEqualityEqualTo:
            return @"eq";
        case BVEqualityGreaterThan:
            return @"gt";
        case BVEqualityGreaterThanOrEqual:
            return @"gte";
        case BVEqualityLessThan:
            return @"lt";
        case BVEqualityLessThanOrEqual:
            return @"lte";
        case BVEqualityNotEqualTo:
            return @"neq";
    }
}


@end
