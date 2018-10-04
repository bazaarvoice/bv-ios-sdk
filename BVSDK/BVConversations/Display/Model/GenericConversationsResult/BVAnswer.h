//
//  BVAnswer.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVGenericConversationsResult.h"

@class BVBadge;
@class BVContextDataValue;
@class BVPhoto;
@class BVSyndicationSource;
@class BVVideo;

/*
 The answer to a question asked by a consumer.

 Commonly used data in an answer:
 Answer text is included in the `answerText` property.
 User nickname is included in the `userNickname` property.
 */
@interface BVAnswer : BVGenericConversationsResult

@property(nullable) NSString *answerText;
@property(nullable) NSString *userNickname;
@property(nullable) NSString *questionId;
@property(nonnull) NSArray<BVPhoto *> *photos;
@property(nonnull) NSArray<BVContextDataValue *> *contextDataValues;
@property(nonnull) NSArray<BVVideo *> *videos;
@property(nonnull) NSArray<BVBadge *> *badges;
@property(nullable) NSString *submissionId;
@property(nullable) NSString *userLocation;
@property(nullable) NSString *authorId;
@property(nullable) NSNumber *isFeatured;
@property(nonnull) NSArray<NSString *> *productRecommendationIds;
@property(nullable) NSDictionary *additionalFields;
@property(nullable) NSNumber *totalFeedbackCount;
@property(nullable) NSNumber *totalPositiveFeedbackCount;
@property(nullable) NSNumber *totalNegativeFeedbackCount;
@property(nullable) NSString *contentLocale;
@property(nullable) NSString *moderationStatus;
@property(nullable) NSString *campaignId;
@property(nullable) NSString *brandImageLogoURL;
@property(nullable) NSString *identifier;
@property(nullable) NSDate *submissionTime;
@property(nullable) NSDate *lastModificationTime;
@property(nullable) NSDate *lastModeratedTime;
@property(readonly) BOOL isSyndicated;
@property(nullable, nonatomic, strong, readonly)
    BVSyndicationSource *syndicationSource;

@end
