//
//  BVQuestion.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import "BVBadge.h"
#import "BVContextDataValue.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVGenericConversationsResult.h"
#import "BVPhoto.h"
#import "BVSyndicationSource.h"
#import "BVVideo.h"
#import <Foundation/Foundation.h>

/*
 A consumer generated question about a product. For example: "Is this toaster
 heavy?" or "How many HDMI ports does this TV have?"

 Some commonly used data in a question:
    Answers to this question are included in the `answers` property.
    Question summary is included in the `questionSummary` property.
    Question details are included in the `questionDetails` property.
 */
@interface BVQuestion : NSObject <BVGenericConversationsResult>

@property(nonnull, nonatomic, copy) NSArray<BVAnswer *> *answers;
@property(nullable, nonatomic, copy) NSString *questionSummary;
@property(nullable, nonatomic, copy) NSString *questionDetails;
@property(nullable, nonatomic, copy) NSString *userNickname;
@property(nullable, nonatomic, strong) TagDimensions tagDimensions;
@property(nonnull, nonatomic, copy) NSArray<BVPhoto *> *photos;
@property(nullable, nonatomic, copy) NSString *categoryId;
@property(nonnull, nonatomic, copy)
    NSArray<BVContextDataValue *> *contextDataValues;
@property(nonnull, nonatomic, copy) NSArray<BVVideo *> *videos;
@property(nullable, nonatomic, copy) NSString *submissionId;
@property(nullable, nonatomic, strong) NSDate *lastModificationTime;
@property(nullable, nonatomic, copy) NSString *userLocation;
@property(nonnull, nonatomic, copy) NSArray<BVBadge *> *badges;
@property(nullable, nonatomic, copy) NSString *authorId;
@property(nonnull, nonatomic, copy)
    NSArray<NSString *> *productRecommendationIds;
@property(nullable, nonatomic, copy) NSString *productId;
@property(nonnull, nonatomic, strong) NSDictionary *additionalFields;
@property(nullable, nonatomic, copy) NSString *campaignId;
@property(nullable, nonatomic, strong) NSDate *submissionTime;
@property(nullable, nonatomic, copy) NSString *contentLocale;
@property(nullable, nonatomic, copy) NSString *moderationStatus;
@property(nullable, nonatomic, copy) NSString *identifier;
@property(nullable, nonatomic, strong) NSDate *lastModeratedTime;
@property(nullable, nonatomic, copy) NSNumber *totalAnswerCount;
@property(nullable, nonatomic, copy) NSNumber *totalFeedbackCount;
@property(nullable, nonatomic, copy) NSNumber *totalPositiveFeedbackCount;
@property(nullable, nonatomic, copy) NSNumber *totalInappropriateFeedbackCount;
@property(nullable, nonatomic, copy) NSNumber *totalNegativeFeedbackCount;
@property bool isFeatured;
@property(readonly) BOOL isSyndicated;
@property(nullable, nonatomic, strong, readonly)
    BVSyndicationSource *syndicationSource;

@end
