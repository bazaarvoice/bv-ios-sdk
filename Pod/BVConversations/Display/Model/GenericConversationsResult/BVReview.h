//
//  BVReview.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVGenericConversationsResult.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVPhoto.h"
#import "BVVideo.h"
#import "BVContextDataValue.h"
#import "BVBadge.h"
#import "BVSecondaryRating.h"
#import "BVSyndicationSource.h"
#import "BVComment.h"

@class BVProduct;

/*
 A consumer generated review about a review.
 
 Some commonly used data in a review:
    Review title is available in the `title` property.
    Review text is available in the `reviewText` property.
    Review rating is availble in the `rating` property.
    User nickname is available in the `userNickname` property.
 */
@interface BVReview : NSObject<BVGenericConversationsResult>

@property NSString* _Nullable reviewText;
@property NSString* _Nullable userNickname;
@property NSString* _Nullable title;
@property int rating;

@property BVProduct* _Nullable product;
@property TagDimensions _Nullable tagDimensions;
@property NSString* _Nullable cons;
@property bool isRecommended;
@property bool isRatingsOnly;
@property bool isSyndicated;
@property NSString* _Nullable pros;
@property NSArray<BVPhoto*>* _Nonnull photos;
@property NSArray<BVContextDataValue*>* _Nonnull contextDataValues;
@property NSArray<BVVideo*>* _Nonnull videos;
@property NSString* _Nullable submissionId;
@property NSNumber* _Nullable totalFeedbackCount;
@property NSNumber* _Nullable totalPositiveFeedbackCount;
@property NSString* _Nullable userLocation;
@property NSArray<BVBadge*>* _Nonnull badges;
@property NSString* _Nullable authorId;
@property bool isFeatured;
@property NSString* _Nullable productId;
@property NSArray<NSString*>* _Nonnull productRecommendationIds;
@property NSDictionary* _Nullable additionalFields;
@property NSString* _Nullable campaignId;
@property NSString* _Nullable helpfulness;
@property NSNumber* _Nullable totalNegativeFeedbackCount;
@property NSString* _Nullable contentLocale;
@property NSString* _Nullable ratingRange;
@property NSNumber* _Nullable totalCommentCount;
@property NSString* _Nullable moderationStatus;
@property NSString* _Nullable identifier;
@property NSArray<NSDictionary*>* _Nonnull clientResponses;
@property NSArray<BVSecondaryRating*>* _Nonnull secondaryRatings;
@property NSDate* _Nullable lastModificationTime;
@property NSDate* _Nullable submissionTime;
@property NSDate* _Nullable lastModeratedTime;
@property BVSyndicationSource* _Nullable syndicationSource;
@property (readonly) NSArray<BVComment *> * _Nonnull comments;

@end
