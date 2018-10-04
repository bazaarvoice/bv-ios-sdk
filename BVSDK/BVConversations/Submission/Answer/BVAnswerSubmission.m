//
//  AnswerSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVAnswerSubmission.h"
#import "BVAnswerSubmissionErrorResponse.h"
#import "BVAnswerSubmissionResponse.h"
#import "BVBaseUGCSubmission+Private.h"
#import "BVCommon.h"
#import "BVFeatureUsedEvent.h"
#import "BVSubmission+Private.h"

@interface BVAnswerSubmission ()

@property(nonnull, readwrite) NSString *questionId;
@property(nonnull) NSString *answerText;

@end

@implementation BVAnswerSubmission

+ (BVPhotoContentType)contentType {
  return BVPhotoContentTypeAnswer;
}

- (nonnull instancetype)initWithQuestionId:(nonnull NSString *)questionId
                                answerText:(nonnull NSString *)answerText {
  if ((self = [super init])) {
    self.questionId = questionId;
    self.answerText = answerText;
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"submitanswer.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];
  parameters[@"answertext"] = self.answerText;
  parameters[@"questionid"] = self.questionId;
  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVAnswerSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVAnswerSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (id<BVAnalyticEvent>)trackEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.questionId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameAnswerQuestion
      withAdditionalParams:nil];
}

- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.questionId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsQuestionAnswer
             withEventName:BVPixelFeatureUsedEventNamePhoto
      withAdditionalParams:@{@"detail1" : @"Answer"}];
}

@end
