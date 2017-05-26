//
//  BVCommentsRequest.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsRequest.h"
#import "BVImpressionEvent.h"
#import "BVPixel.h"

@implementation BVCommentsRequest

- (nonnull instancetype)initWithReviewId:(NSString * _Nonnull)reviewId limit:(UInt16)limit offset:(UInt16)offset{
    
    self = [super init];
    if(self){
        
        _reviewId = reviewId;
        _limit = limit;
        _offset = offset;
        _filters = [NSMutableArray array];
        _sorts = [NSMutableArray array];
        _includes = [NSMutableArray array];
    }
    
    return self;
}
    
- (nonnull instancetype)initWithCommentId:(NSString * _Nonnull)commentId{
    
    self = [super init];
    if(self){
        
        _commentId = commentId;
        _filters = [NSMutableArray array];
        _sorts = [NSMutableArray array];
        _includes = [NSMutableArray array];
    }
    
    return self;
}
   
- (void)load:(void (^ _Nonnull)(BVCommentsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure{
    
    if (self.reviewId && (self.limit < 1 || self.limit > 100)) {
        // invalid request
        [self sendError:[super limitError:self.limit] failureCallback:failure];
    }
    else {
        [self loadComments:self completion:success failure:failure];
    }
    
}
  
- (void)loadComments:(BVConversationsRequest * _Nonnull)request completion:(void (^ _Nonnull)(BVCommentsResponse * _Nonnull response))completion failure:(void (^ _Nonnull)(NSArray<NSError *> * _Nonnull errors))failure {
    
    [self loadContent:request completion:^(NSDictionary * _Nonnull response) {
        
        BVCommentsResponse *commentsResponse = [[BVCommentsResponse alloc] initWithApiResponse:response];
        
        // invoke success callback on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(commentsResponse);
        });

        if (commentsResponse && commentsResponse.results){
            [self sendCommentImpressionAnalytics:commentsResponse.results];
        }
        
    } failure:failure];
}

- (NSString * _Nonnull)endpoint {
    return @"reviewcomments.json";
}

- (void)sendCommentImpressionAnalytics:(NSArray<BVComment*>*)comments {
    
    for (BVComment* comment in comments) {
        
        // Record Review Impression
        BVImpressionEvent *commentImpression = [[BVImpressionEvent alloc] initWithProductId:comment.reviewId
                                                                             withContentId:comment.commentId
                                                                            withCategoryId:nil
                                                                           withProductType:BVPixelProductTypeConversationsReviews
                                                                           withContentType:BVPixelImpressionContentTypeComment
                                                                                 withBrand:nil
                                                                      withAdditionalParams:nil];
        
        [BVPixel trackEvent:commentImpression];
    }

    
}

- (NSMutableArray * _Nonnull)createParams {
    
    NSMutableArray<BVStringKeyValuePair*>* params = [super createParams];
    
    // There are two ways to make a request: 1) with a review Id to get a bunch of comments or 2) just get single review.
    if (self.reviewId) {
        
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[NSString stringWithFormat:@"reviewId:%@", self.reviewId]]];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Limit" value: [NSString stringWithFormat:@"%i", self.limit]]];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Offset" value: [NSString stringWithFormat:@"%i", self.offset]]];
        
    } else if (self.commentId) {
        BVFilter *commentIdFilter = [[BVFilter alloc] initWithType:BVProductFilterTypeId filterOperator:BVFilterOperatorEqualTo value:self.commentId];
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[commentIdFilter toParameterString]]];
        
    } else {
        
        NSAssert(NO, @"You must supply a valid comment or review ID in the supplied initiaizers.");
        
    }
    
    for(BVFilter* filter in self.filters) {
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Filter" value:[filter toParameterString]]];
    }
    
    if (self.sorts.count > 0){
        [params addObject:[self sortParams:self.sorts withKey:@"Sort"]];
    }
    
    if (self.includes.count > 0){
        [params addObject:[BVStringKeyValuePair pairWithKey:@"Include" value:[self includesToParams:self.includes]]];
    }
    
    return params;
}


- (nonnull instancetype)addCommentSort:(BVSortOptionComments)option order:(BVSortOrder)order{
    BVSort* sort = [[BVSort alloc] initWithOptionString:[BVSortOptionsCommentUtil toString:option] order:order];
    [self.sorts addObject:sort];
    return self;
}

- (nonnull instancetype)addFilter:(BVCommentFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value{
    [self addFilter:type filterOperator:filterOperator values:@[value]];
    return self;
}

- (nonnull instancetype)addInclude:(BVCommentIncludeType)include{
    
    [self.includes addObject:[BVCommentIncludeTypeUtil toString:include]];
    return self;
    
}

- (nonnull instancetype)addFilter:(BVCommentFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values {
    BVFilter* filter = [[BVFilter alloc] initWithString:[BVCommentFilterTypeUtil toString:type] filterOperator:filterOperator values:values];
    [self.filters addObject:filter];
    return self;
}

-(BVStringKeyValuePair* _Nonnull)sortParams:(NSArray<BVSort*>* _Nonnull)sorts withKey:(NSString*)paramKey {
    
    NSMutableArray* strings = [NSMutableArray array];
    
    for(BVSort* sort in sorts) {
        [strings addObject:[sort toString]];
    }
    
    NSString* combined = [strings componentsJoinedByString:@","];
    
    return [BVStringKeyValuePair pairWithKey:paramKey value:combined];
    
}

-(NSString* _Nonnull)includesToParams:(NSArray<NSString *>* _Nonnull)includes {
    
    
    NSArray<NSString*>* sortedArray = [includes sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return [sortedArray componentsJoinedByString:@","];
    
}

@end
