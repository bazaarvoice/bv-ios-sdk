//
//  BVAuthor.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil.h"
#import "BVGenericConversationsResult.h"

@class BVAnswer;
@class BVBadge;
@class BVComment;
@class BVContextDataValue;
@class BVPhoto;
@class BVQAStatistics;
@class BVQuestion;
@class BVReview;
@class BVReviewStatistics;
@class BVSecondaryRating;
@class BVVideo;

@interface BVAuthor : BVGenericConversationsResult

@property(nullable) NSString *userNickname;
@property(nullable) NSString *authorId;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSDate *lastModeratedTime;
@property(nullable) TagDimensions tagDimensions;
@property(nonnull) NSArray<BVPhoto *> *photos;
@property(nonnull) NSArray<BVContextDataValue *> *contextDataValues;
@property(nonnull) NSArray<BVVideo *> *videos;
@property(nullable) NSString *submissionId;
@property(nullable) NSString *userLocation;
@property(nonnull) NSArray<BVBadge *> *badges;
@property(nonnull) NSArray<BVSecondaryRating *> *secondaryRatings;

@property(nonnull, readonly) NSArray<BVReview *> *includedReviews;
@property(nonnull, readonly) NSArray<BVQuestion *> *includedQuestions;
@property(nonnull, readonly) NSArray<BVAnswer *> *includedAnswers;
@property(nonnull, readonly) NSArray<BVComment *> *includedComments;

@property(nullable) BVReviewStatistics *reviewStatistics;
@property(nullable) BVQAStatistics *qaStatistics;

@end
