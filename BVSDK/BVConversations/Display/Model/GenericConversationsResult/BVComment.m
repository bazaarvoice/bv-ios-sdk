//
//  BVComment.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVComment.h"
#import "BVAnswer.h"
#import "BVAuthor.h"
#import "BVBadge.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"
#import "BVProduct.h"
#import "BVQuestion.h"
#import "BVReview.h"
#import "BVSyndicationSource.h"

@interface BVComment ()

@property(nonnull, readwrite) NSArray<BVAnswer *> *includedAnswers;
@property(nonnull, readwrite) NSArray<BVAuthor *> *includedAuthors;
@property(nonnull, readwrite) NSArray<BVProduct *> *includedProducts;
@property(nonnull, readwrite) NSArray<BVQuestion *> *includedQuestions;
@property(nonnull, readwrite) NSArray<BVReview *> *includedReviews;

@end

@implementation BVComment

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  if ((self = [super init])) {

    if (!includes) {
      includes =
          [[BVConversationsInclude alloc] initWithApiResponse:apiResponse];
    }

    SET_IF_NOT_NULL(_userNickname, apiResponse[@"UserNickname"])
    SET_IF_NOT_NULL(_userLocation, apiResponse[@"UserLocation"])
    SET_IF_NOT_NULL(_authorId, apiResponse[@"AuthorId"])
    SET_IF_NOT_NULL(_reviewId, apiResponse[@"ReviewId"])
    SET_IF_NOT_NULL(_commentId, apiResponse[@"Id"])
    SET_IF_NOT_NULL(_commentText, apiResponse[@"CommentText"])
    SET_IF_NOT_NULL(_title, apiResponse[@"Title"])

    SET_IF_NOT_NULL(_submissionId, apiResponse[@"SubmissionId"])
    SET_IF_NOT_NULL(_totalFeedbackCount, apiResponse[@"TotalFeedbackCount"])
    SET_IF_NOT_NULL(_totalPositiveFeedbackCount,
                    apiResponse[@"TotalPositiveFeedbackCount"])
    SET_IF_NOT_NULL(_totalNegativeFeedbackCount,
                    apiResponse[@"TotalNegativeFeedbackCount"])
    SET_IF_NOT_NULL(_contentLocale, apiResponse[@"ContentLocale"])
    SET_IF_NOT_NULL(_campaignId, apiResponse[@"CampaignId"])

    _submissionTime =
        [BVModelUtil convertTimestampToDatetime:apiResponse[@"SubmissionTime"]];
    _lastModeratedTime = [BVModelUtil
        convertTimestampToDatetime:apiResponse[@"LastModeratedTime"]];
    _lastModificationTime = [BVModelUtil
        convertTimestampToDatetime:apiResponse[@"LastModificationTime"]];

    NSNumber *isSyndicated = apiResponse[@"IsSyndicated"];
    if (![isSyndicated isKindOfClass:[NSNull class]]) {
      _isSyndicated = [isSyndicated boolValue];

      if (self.isSyndicated) {
        _syndicationSource =
            [[BVSyndicationSource alloc] initWithApiResponse:apiResponse];
      }
    }

    _badges = [BVModelUtil parseBadges:apiResponse[@"Badges"]];

    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedAnswers, includes,
                                             Answer);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedAuthors, includes,
                                             Author);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedProducts, includes,
                                             Product);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedQuestions, includes,
                                             Question);
    GET_BVOBJECTS_FROM_CONVERSATIONS_INCLUDE(_includedReviews, includes,
                                             Review);
  }

  return self;
}

@end
