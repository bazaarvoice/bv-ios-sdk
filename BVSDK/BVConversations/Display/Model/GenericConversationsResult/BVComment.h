//
//  BVComment.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVGenericConversationsResult.h"

@class BVAnswer;
@class BVAuthor;
@class BVBadge;
@class BVProduct;
@class BVQuestion;
@class BVReview;
@class BVSyndicationSource;

@interface BVComment : BVGenericConversationsResult

@property(nullable, readonly) NSString *title;
@property(nullable, readonly) NSString *commentText;
@property(nullable, readonly) NSString *reviewId;
@property(nullable, readonly) NSString *commentId;
@property(nullable, readonly) NSString *campaignId;

@property(nullable, readonly) NSString *userNickname;
@property(nullable, readonly) NSString *authorId;
@property(nullable, readonly) NSString *userLocation;
@property(nullable, readonly) NSDate *submissionTime;
@property(nullable, readonly) NSDate *lastModeratedTime;
@property(nullable, readonly) NSDate *lastModificationTime;

@property(nullable, readonly) NSString *submissionId;
@property(nullable, readonly) NSNumber *totalFeedbackCount;
@property(nullable, readonly) NSNumber *totalPositiveFeedbackCount;
@property(nullable, readonly) NSNumber *totalNegativeFeedbackCount;

@property(nullable, readonly) NSString *contentLocale;

@property(nonnull, readonly) NSArray<BVBadge *> *badges;

@property(readonly) BOOL isSyndicated;
@property(nullable, nonatomic, strong, readonly)
    BVSyndicationSource *syndicationSource;

@property(nonnull, readonly) NSArray<BVAnswer *> *includedAnswers;
@property(nonnull, readonly) NSArray<BVAuthor *> *includedAuthors;
@property(nonnull, readonly) NSArray<BVProduct *> *includedProducts;
@property(nonnull, readonly) NSArray<BVQuestion *> *includedQuestions;
@property(nonnull, readonly) NSArray<BVReview *> *includedReviews;

@end
