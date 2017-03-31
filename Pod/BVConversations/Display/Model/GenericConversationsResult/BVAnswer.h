//
//  BVAnswer.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVContextDataValue.h"
#import "BVBadge.h"
#import "BVGenericConversationsResult.h"
#import "BVPhoto.h"
#import "BVVideo.h"

/*
 The answer to a question asked by a consumer.

 Commonly used data in an answer:
    Answer text is included in the `answerText` property.
    User nickname is included in the `userNickname` property.
 */
@interface BVAnswer : NSObject<BVGenericConversationsResult>

@property NSString* _Nullable answerText;
@property NSString* _Nullable userNickname;
@property NSString* _Nullable questionId;
@property NSArray<BVPhoto*>* _Nonnull photos;
@property NSArray<BVContextDataValue*>* _Nonnull contextDataValues;
@property NSArray<BVVideo*>* _Nonnull videos;
@property NSArray<BVBadge*>* _Nonnull badges;
@property NSString* _Nullable submissionId;
@property NSString* _Nullable userLocation;
@property NSString* _Nullable authorId;
@property NSNumber* _Nullable isFeatured;
@property NSArray<NSString*>* _Nonnull productRecommendationIds;
@property NSDictionary* _Nullable additionalFields;
@property NSNumber* _Nullable totalFeedbackCount;
@property NSNumber* _Nullable totalPositiveFeedbackCount;
@property NSNumber* _Nullable totalNegativeFeedbackCount;
@property NSString* _Nullable contentLocale;
@property NSString* _Nullable moderationStatus;
@property NSString* _Nullable campaignId;
@property NSString* _Nullable brandImageLogoURL;
@property NSString* _Nullable identifier;
@property NSDate* _Nullable submissionTime;
@property NSDate* _Nullable lastModificationTime;
@property NSDate* _Nullable lastModeratedTime;

@end
