//
//  BVReview.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil.h"
#import "BVGenericConversationsResult.h"

@class BVBadge;
@class BVComment;
@class BVContextDataValue;
@class BVPhoto;
@class BVProduct;
@class BVSecondaryRating;
@class BVSyndicationSource;
@class BVVideo;

/*
 A consumer generated review about a review.

 Some commonly used data in a review:
    Review title is available in the `title` property.
    Review text is available in the `reviewText` property.
    Review rating is availble in the `rating` property.
    User nickname is available in the `userNickname` property.
 */
@interface BVReview : BVGenericConversationsResult

@property(nullable) NSString *reviewText;
@property(nullable) NSString *userNickname;
@property(nullable) NSString *title;
@property NSUInteger rating;
@property(nullable) BVProduct *product;
@property(nullable) TagDimensions tagDimensions;
@property(nullable) NSString *cons;
@property bool isRecommended;
@property bool isRatingsOnly;
@property bool isSyndicated;
@property(nullable) NSString *pros;
@property(nonnull) NSArray<BVPhoto *> *photos;
@property(nonnull) NSArray<BVContextDataValue *> *contextDataValues;
@property(nonnull) NSArray<BVVideo *> *videos;
@property(nullable) NSString *submissionId;
@property(nullable) NSNumber *totalFeedbackCount;
@property(nullable) NSNumber *totalPositiveFeedbackCount;
@property(nullable) NSString *userLocation;
@property(nonnull) NSArray<BVBadge *> *badges;
@property(nullable) NSString *authorId;
@property bool isFeatured;
@property(nullable) NSString *productId;
@property(nonnull) NSArray<NSString *> *productRecommendationIds;
@property(nullable) NSDictionary *additionalFields;
@property(nullable) NSString *campaignId;
@property(nullable) NSString *helpfulness;
@property(nullable) NSNumber *totalNegativeFeedbackCount;
@property(nullable) NSString *contentLocale;
@property(nullable) NSString *ratingRange;
@property(nullable) NSNumber *totalCommentCount;
@property(nullable) NSString *moderationStatus;
@property(nullable) NSString *identifier;
@property(nonnull) NSArray<NSDictionary *> *clientResponses;
@property(nonnull) NSArray<BVSecondaryRating *> *secondaryRatings;
@property(nullable) NSDate *lastModificationTime;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSDate *lastModeratedTime;
@property(nullable, nonatomic, strong, readonly)
    BVSyndicationSource *syndicationSource;

@property(nonnull, readonly) NSArray<BVComment *> *includedComments;

@end
