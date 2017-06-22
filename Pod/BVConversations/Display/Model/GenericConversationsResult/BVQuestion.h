//
//  BVQuestion.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVGenericConversationsResult.h"
#import "BVAnswer.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVPhoto.h"
#import "BVVideo.h"
#import "BVContextDataValue.h"
#import "BVBadge.h"
#import "BVSyndicationSource.h"

/*
 A consumer generated question about a product. For example: "Is this toaster heavy?" or "How many HDMI ports does this TV have?"
 
 Some commonly used data in a question:
    Answers to this question are included in the `answers` property.
    Question summary is included in the `questionSummary` property.
    Question details are included in the `questionDetails` property.
 */
@interface BVQuestion : NSObject <BVGenericConversationsResult>

@property (nonatomic, copy) NSArray<BVAnswer *> * _Nonnull answers;
@property (nonatomic, copy) NSString * _Nullable questionSummary;
@property (nonatomic, copy) NSString * _Nullable questionDetails;
@property (nonatomic, copy) NSString * _Nullable userNickname;
@property (nonatomic, strong) TagDimensions _Nullable tagDimensions;
@property (nonatomic, copy) NSArray<BVPhoto *> * _Nonnull photos;
@property (nonatomic, copy) NSString * _Nullable categoryId;
@property (nonatomic, copy) NSArray<BVContextDataValue *> * _Nonnull contextDataValues;
@property (nonatomic, copy) NSArray<BVVideo *> * _Nonnull videos;
@property (nonatomic, copy) NSString * _Nullable submissionId;
@property (nonatomic, strong) NSDate * _Nullable lastModificationTime;
@property (nonatomic, copy) NSString * _Nullable userLocation;
@property (nonatomic, copy) NSArray<BVBadge *> * _Nonnull badges;
@property (nonatomic, copy) NSString * _Nullable authorId;
@property (nonatomic, copy) NSArray<NSString *> * _Nonnull productRecommendationIds;
@property (nonatomic, copy) NSString * _Nullable productId;
@property (nonatomic, strong) NSDictionary * _Nonnull additionalFields;
@property (nonatomic, copy) NSString * _Nullable campaignId;
@property (nonatomic, strong) NSDate * _Nullable submissionTime;
@property (nonatomic, copy) NSString * _Nullable contentLocale;
@property (nonatomic, copy) NSString * _Nullable moderationStatus;
@property (nonatomic, copy) NSString * _Nullable identifier;
@property (nonatomic, strong) NSDate * _Nullable lastModeratedTime;
@property (nonatomic, copy) NSNumber* _Nullable totalAnswerCount;
@property (nonatomic, copy) NSNumber* _Nullable totalFeedbackCount;
@property (nonatomic, copy) NSNumber* _Nullable totalPositiveFeedbackCount;
@property (nonatomic, copy) NSNumber* _Nullable totalInappropriateFeedbackCount;
@property (nonatomic, copy) NSNumber* _Nullable totalNegativeFeedbackCount;
@property bool isFeatured;
@property (readonly) BOOL isSyndicated;
@property (nonatomic, strong, readonly, nullable) BVSyndicationSource* syndicationSource;

@end
