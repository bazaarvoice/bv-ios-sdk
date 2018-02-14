

//
//  BVCommentsRequest.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsResponse.h"
#import "BVConversationDisplay.h"
#import "BVConversationsRequest.h"

@interface BVCommentsRequest : BVConversationsRequest

@property(nonnull, readonly) NSString *productId;
@property(nullable, readonly) NSString *reviewId;
@property(nullable, readonly) NSString *commentId;
@property(nonatomic, assign, readonly) UInt16 limit;
@property(nonatomic, assign, readonly) UInt16 offset;

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                              andReviewId:(nonnull NSString *)reviewId
                                    limit:(UInt16)limit
                                   offset:(UInt16)offset;
- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId
                             andCommentId:(nonnull NSString *)commentId;

- (nonnull instancetype)__unavailable init;

- (nonnull instancetype)
sortByCommentsSortOptionValue:(BVCommentsSortOptionValue)commentsSortOptionValue
      monotonicSortOrderValue:
          (BVMonotonicSortOrderValue)monotonicSortOrderValue;

- (nonnull instancetype)
   filterOnCommentFilterValue:(BVCommentFilterValue)commentFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                        value:(nonnull NSString *)value;

- (nonnull instancetype)
   filterOnCommentFilterValue:(BVCommentFilterValue)commentFilterValue
relationalFilterOperatorValue:
    (BVRelationalFilterOperatorValue)relationalFilterOperatorValue
                       values:(nonnull NSArray<NSString *> *)values;

- (nonnull instancetype)includeCommentIncludeTypeValue:
    (BVCommentIncludeTypeValue)commentIncludeTypeValue;

/// Make an asynch http request to fethre the Author's profile data. See the
/// BVAuthorResponse model for availble fields.
- (void)load:(nonnull void (^)(BVCommentsResponse *__nonnull response))success
     failure:(nonnull ConversationsFailureHandler)failure;

@end
