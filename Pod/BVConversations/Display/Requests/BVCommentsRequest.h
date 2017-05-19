//
//  BVCommentsRequest.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVConversationsRequest.h"
#import "BVCommentsResponse.h"
#import "BVSort.h"
#import "BVFilter.h"
#import "BVSortOptionsComments.h"
#import "BVCommentFilterType.h"
#import "BVCommentIncludeType.h"

@interface BVCommentsRequest : BVConversationsRequest

@property (readonly) NSString* _Nonnull reviewId;
@property (nonatomic, assign, readonly) UInt16 limit;
@property (nonatomic, assign, readonly) UInt16 offset;
@property (nonatomic, strong, readonly) NSMutableArray<BVSort*>* _Nonnull sorts;
@property (nonatomic, strong, readonly) NSMutableArray<BVFilter*>* _Nonnull filters;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> * _Nonnull includes;
@property (readonly) NSString* _Nonnull commentId;

- (nonnull instancetype)initWithReviewId:(NSString * _Nonnull)reviewId limit:(UInt16)limit offset:(UInt16)offset;
- (nonnull instancetype)initWithCommentId:(NSString * _Nonnull)commentId;
    
- (nonnull instancetype) __unavailable init;

- (nonnull instancetype)addCommentSort:(BVSortOptionComments)option order:(BVSortOrder)order;

- (nonnull instancetype)addFilter:(BVCommentFilterType)type filterOperator:(BVFilterOperator)filterOperator value:(NSString * _Nonnull)value;

- (nonnull instancetype)addFilter:(BVCommentFilterType)type filterOperator:(BVFilterOperator)filterOperator values:(NSArray<NSString *> * _Nonnull)values;

- (nonnull instancetype)addInclude:(BVCommentIncludeType)include;

    /// Make an asynch http request to fethre the Author's profile data. See the BVAuthorResponse model for availble fields.
- (void)load:(void (^ _Nonnull)(BVCommentsResponse * _Nonnull response))success failure:(ConversationsFailureHandler _Nonnull)failure;
    
@end
