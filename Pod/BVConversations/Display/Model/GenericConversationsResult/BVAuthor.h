//
//  BVAuthor.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BVGenericConversationsResult.h"
#import "BVPhoto.h"
#import "BVVideo.h"
#import "BVBadge.h"
#import "BVContextDataValue.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVSecondaryRating.h"
#import "BVReview.h"
#import "BVQuestion.h"
#import "BVAnswer.h"
#import "BVReviewStatistics.h"
#import "BVQAStatistics.h"

@interface BVAuthor : NSObject<BVGenericConversationsResult>

@property NSString* _Nullable userNickname;
@property NSString* _Nullable authorId;
@property NSDate* _Nullable submissionTime;
@property NSDate* _Nullable lastModeratedTime;
@property TagDimensions _Nullable tagDimensions;
@property NSArray<BVPhoto*>* _Nonnull photos;
@property NSArray<BVContextDataValue*>* _Nonnull contextDataValues;
@property NSArray<BVVideo*>* _Nonnull videos;
@property NSString* _Nullable submissionId;
@property NSString* _Nullable userLocation;
@property NSArray<BVBadge*>* _Nonnull badges;
@property NSArray<BVSecondaryRating*>* _Nonnull secondaryRatings;

@property NSArray<BVReview*>* _Nonnull includedReviews;
@property NSArray<BVQuestion*>* _Nonnull includedQuestions;
@property NSArray<BVAnswer*>* _Nonnull includedAnswers;
@property NSArray<BVComment*>* _Nonnull includedComments;

@property BVReviewStatistics* _Nullable reviewStatistics;
@property BVQAStatistics* _Nullable qaStatistics;

@property (nonatomic, strong, readonly) BVConversationsInclude * _Nullable includes;

@end
