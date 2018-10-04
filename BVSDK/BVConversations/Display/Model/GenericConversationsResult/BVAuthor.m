//
//  BVAuthor.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthor.h"
#import "BVAnswer.h"
#import "BVBadge.h"
#import "BVContextDataValue.h"
#import "BVConversationsInclude.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"
#import "BVPhoto.h"
#import "BVQAStatistics.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVReviewStatistics.h"
#import "BVSecondaryRating.h"
#import "BVVideo.h"

@interface BVAuthor ()

@property(nonnull, readwrite) NSArray<BVAnswer *> *includedAnswers;
@property(nonnull, readwrite) NSArray<BVComment *> *includedComments;
@property(nonnull, readwrite) NSArray<BVQuestion *> *includedQuestions;
@property(nonnull, readwrite) NSArray<BVReview *> *includedReviews;

@end

@implementation BVAuthor

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  if ((self = [super init])) {

    if (!includes) {
      includes =
          [[BVConversationsInclude alloc] initWithApiResponse:apiResponse];
    }

    SET_IF_NOT_NULL(self.userNickname, apiResponse[@"UserNickname"])
    SET_IF_NOT_NULL(self.userLocation, apiResponse[@"Location"])
    SET_IF_NOT_NULL(self.authorId, apiResponse[@"Id"])

    self.reviewStatistics = [[BVReviewStatistics alloc]
        initWithApiResponse:apiResponse[@"ReviewStatistics"]];
    self.qaStatistics = [[BVQAStatistics alloc]
        initWithApiResponse:apiResponse[@"QAStatistics"]];

    self.submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiResponse[@"SubmissionTime"]];
    self.lastModeratedTime = [BVModelUtil
        convertTimestampToDatetime:apiResponse[@"LastModeratedTime"]];

    self.tagDimensions =
        [BVModelUtil parseTagDimension:apiResponse[@"TagDimensions"]];
    self.photos = [BVModelUtil parsePhotos:apiResponse[@"Photos"]];
    self.videos = [BVModelUtil parseVideos:apiResponse[@"Videos"]];
    self.contextDataValues =
        [BVModelUtil parseContextDataValues:apiResponse[@"ContextDataValues"]];
    self.badges = [BVModelUtil parseBadges:apiResponse[@"Badges"]];
    self.secondaryRatings =
        [BVModelUtil parseSecondaryRatings:apiResponse[@"SecondaryRatings"]];

    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedAnswers, includes,
                                             Answer);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedComments, includes,
                                             Comment);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedQuestions, includes,
                                             Question);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedReviews, includes,
                                             Review);
  }
  return self;
}

@end
