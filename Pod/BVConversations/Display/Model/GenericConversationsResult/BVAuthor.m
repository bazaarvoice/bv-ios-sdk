//
//  BVAuthor.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthor.h"
#import "BVConversationsInclude.h"
#import "BVModelUtil.h"
#import "BVNullHelper.h"

@implementation BVAuthor

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  self = [super init];
  if (self) {
    _includes = includes;

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

    NSArray<NSString *> *reviewIds = apiResponse[@"ReviewIds"];
    NSMutableArray<BVReview *> *tempReviews = [NSMutableArray array];
    for (NSString *reviewId in reviewIds) {
      BVReview *review = [includes getReviewById:reviewId];
      [tempReviews addObject:review];
    }
    self.includedReviews = tempReviews;

    NSArray<NSString *> *questionIds = apiResponse[@"QuestionIds"];
    NSMutableArray<BVQuestion *> *tempQuestions = [NSMutableArray array];
    for (NSString *questionId in questionIds) {
      BVQuestion *question = [includes getQuestionById:questionId];
      [tempQuestions addObject:question];
    }
    self.includedQuestions = tempQuestions;

    NSArray<NSString *> *commentIds = apiResponse[@"CommentIds"];
    NSMutableArray<BVComment *> *tempComments = [NSMutableArray array];
    for (NSString *commentId in commentIds) {
      BVComment *comment = [includes getCommentById:commentId];
      [tempComments addObject:comment];
    }
    self.includedComments = tempComments;

    NSArray<NSString *> *answerIds = apiResponse[@"AnswerIds"];
    NSMutableArray<BVAnswer *> *tempAnswers = [NSMutableArray array];
    for (NSString *answerId in answerIds) {
      BVAnswer *answer = [includes getAnswerById:answerId];
      [tempAnswers addObject:answer];
    }
    self.includedAnswers = tempAnswers;
  }
  return self;
}

@end
