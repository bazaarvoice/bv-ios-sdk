//
//  BVAuthor.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAnswer.h"
#import "BVBadge.h"
#import "BVContextDataValue.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVGenericConversationsResult.h"
#import "BVPhoto.h"
#import "BVQAStatistics.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVReviewStatistics.h"
#import "BVSecondaryRating.h"
#import "BVVideo.h"
#import <UIKit/UIKit.h>

@interface BVAuthor : NSObject <BVGenericConversationsResult>

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

@property(nonnull) NSArray<BVReview *> *includedReviews;
@property(nonnull) NSArray<BVQuestion *> *includedQuestions;
@property(nonnull) NSArray<BVAnswer *> *includedAnswers;
@property(nonnull) NSArray<BVComment *> *includedComments;

@property(nullable) BVReviewStatistics *reviewStatistics;
@property(nullable) BVQAStatistics *qaStatistics;

@property(nullable, nonatomic, strong, readonly)
    BVConversationsInclude *includes;

@end
