//
//  BVFeedbackSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFeedbackSubmission.h"
#import "BVFeedbackSubmissionErrorResponse.h"
#import "BVFeedbackSubmissionResponse.h"
#import "BVPixel.h"
#import "BVSubmission+Private.h"

@implementation BVFeedbackSubmission

- (nonnull instancetype)initWithContentId:(nonnull NSString *)contentId
                          withContentType:(BVFeedbackContentType)contentType
                         withFeedbackType:(BVFeedbackType)feedbackType {
  if ((self = [super init])) {
    self.contentId = contentId;
    self.feedbackType = feedbackType;
    self.contentType = contentType;
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"submitfeedback.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters =
      [NSMutableDictionary dictionaryWithDictionary:@{@"apiversion" : @"5.4"}];

  parameters[@"passkey"] = self.conversationsKey;
  parameters[@"userid"] = self.userId;
  parameters[@"contentId"] = self.contentId;

  switch (self.contentType) {
  case BVFeedbackContentTypeAnswer:
    parameters[@"contentType"] = @"answer";
    break;
  case BVFeedbackContentTypeQuestion:
    parameters[@"contentType"] = @"question";
    break;
  case BVFeedbackContentTypeReview:
    parameters[@"contentType"] = @"review";
    break;
  default:
    break;
  }

  switch (self.feedbackType) {
  case BVFeedbackTypeHelpfulness:
    parameters[@"feedbackType"] = @"helpfulness";
    parameters[@"vote"] =
        (BVFeedbackVotePositive == self.vote) ? @"positive" : @"negative";
    break;
  case BVFeedbackTypeInappropriate:
    parameters[@"feedbackType"] = @"inappropriate";
    break;
  default:
    break;
  }

  if (self.reasonText) {
    parameters[@"reasonText"] = self.reasonText;
  }

  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVFeedbackSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVFeedbackSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (id<BVAnalyticEvent>)trackEvent {

  // Fire event now that we've confirmed the answer was successfully uploaded.

  BVPixelImpressionContentType contentType = BVPixelImpressionContentTypeReview;
  BVPixelProductType productTypeForEvent =
      BVPixelProductTypeConversationsReviews;

  switch (self.contentType) {
  case BVFeedbackContentTypeAnswer:
    contentType = BVPixelImpressionContentTypeAnswer;
    productTypeForEvent = BVPixelProductTypeConversationsQuestionAnswer;
    break;
  case BVFeedbackContentTypeQuestion:
    contentType = BVPixelImpressionContentTypeQuestion;
    productTypeForEvent = BVPixelProductTypeConversationsQuestionAnswer;
    break;
  case BVFeedbackContentTypeReview:
    contentType = BVPixelImpressionContentTypeReview;
    productTypeForEvent = BVPixelProductTypeConversationsReviews;
    break;
  default:
    break;
  }

  BVPixelFeatureUsedEventName featureUsed = BVPixelFeatureUsedEventNameFeedback;
  NSString *detail1 = @"";

  switch (self.feedbackType) {
  case BVFeedbackTypeHelpfulness:
    featureUsed = BVPixelFeatureUsedEventNameFeedback;
    detail1 = (BVFeedbackVotePositive == self.vote) ? @"Positive" : @"Negative";
    break;
  case BVFeedbackTypeInappropriate:
    featureUsed = BVPixelFeatureUsedEventNameInappropriate;
    detail1 = @"Inappropriate";
    break;
  default:
    break;
  }

  NSDictionary *additionalParams = @{
    @"contentType" : [BVPixelImpressionContentTypeUtil toString:contentType],
    @"contentId" : self.contentId,
    @"detail1" : detail1
  };

  BVFeatureUsedEvent *feedbackEvent =
      [[BVFeatureUsedEvent alloc] initWithProductId:self.contentId
                                          withBrand:nil
                                    withProductType:productTypeForEvent
                                      withEventName:featureUsed
                               withAdditionalParams:additionalParams];

  return feedbackEvent;
}

@end
