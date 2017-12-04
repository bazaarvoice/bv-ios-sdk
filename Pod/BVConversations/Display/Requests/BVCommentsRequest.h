

//
//  BVCommentsRequest.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentFilterType.h"
#import "BVCommentIncludeType.h"
#import "BVCommentsResponse.h"
#import "BVConversationsRequest.h"
#import "BVFilter.h"
#import "BVSort.h"
#import "BVSortOptionsComments.h"

@interface BVCommentsRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *reviewId;
@property(nonatomic, assign, readonly) UInt16 limit;
@property(nonatomic, assign, readonly) UInt16 offset;
@property(nonnull, nonatomic, strong, readonly) NSMutableArray<BVSort *> *sorts;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<BVFilter *> *filters;
@property(nonnull, nonatomic, strong, readonly)
    NSMutableArray<NSString *> *includes;
@property(nonnull, readonly) NSString *commentId;

- (nonnull instancetype)initWithReviewId:(nonnull NSString *)reviewId
                                   limit:(UInt16)limit
                                  offset:(UInt16)offset;
- (nonnull instancetype)initWithCommentId:(nonnull NSString *)commentId;

- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)addCommentSort:(BVSortOptionComments)option
                                 order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVCommentFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                            value:(nonnull NSString *)value;

- (nonnull instancetype)addFilter:(BVCommentFilterType)type
                   filterOperator:(BVFilterOperator)filterOperator
                           values:(nonnull NSArray<NSString *> *)values;

- (nonnull instancetype)addInclude:(BVCommentIncludeType)include;

/// Make an asynch http request to fethre the Author's profile data. See the
/// BVAuthorResponse model for availble fields.
- (void)load:(nonnull void (^)(BVCommentsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
