//
//  BVQuestionSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVQuestionSubmission.h"
#import "BVBaseUGCSubmission+Private.h"
#import "BVFeatureUsedEvent.h"
#import "BVQuestionSubmissionErrorResponse.h"
#import "BVQuestionSubmissionResponse.h"

@interface BVQuestionSubmission ()
@property(nonnull, readwrite) NSString *productId;
@end

@implementation BVQuestionSubmission

+ (BVPhotoContentType)contentType {
  return BVPhotoContentTypeQuestion;
}

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId {
  if ((self = [super init])) {
    self.productId = productId;
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"submitquestion.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];
  parameters[@"productId"] = self.productId;
  parameters[@"questionsummary"] = self.questionSummary;
  parameters[@"questiondetails"] = self.questionDetails;

  if (self.isUserAnonymous) {
    parameters[@"isuseranonymous"] =
        [self.isUserAnonymous boolValue] ? @"true" : @"false";
  }

  if (self.sendEmailAlertWhenPublished) {
    parameters[@"sendemailalertwhenpublished"] =
        [self.sendEmailAlertWhenPublished boolValue] ? @"true" : @"false";
  }

  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVQuestionSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVQuestionSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.productId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameAskQuestion
      withAdditionalParams:nil];
}

- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.productId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsQuestionAnswer
             withEventName:BVPixelFeatureUsedEventNamePhoto
      withAdditionalParams:nil];
}

@end
