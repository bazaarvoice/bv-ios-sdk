//
//  BVCommentSubmission.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentSubmission.h"
#import "BVBaseUGCSubmission+Private.h"
#import "BVCommentSubmissionErrorResponse.h"
#import "BVCommentSubmissionResponse.h"
#import "BVFeatureUsedEvent.h"

@implementation BVCommentSubmission

+ (BVPhotoContentType)contentType {
  return BVPhotoContentTypeComment;
}

- (nonnull instancetype)initWithReviewId:(NSString *)reviewId
                         withCommentText:(NSString *)commentText {
  if ((self = [super init])) {
    _reviewId = reviewId;
    _commentText = commentText;
  }
  return self;
}

- (nonnull NSString *)endpoint {
  return @"submitreviewcomment.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];
  parameters[@"commenttext"] = _commentText;
  parameters[@"reviewid"] = _reviewId;

  if (self.commentTitle) {
    parameters[@"title"] = self.commentTitle;
  }

  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVCommentSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVCommentSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.reviewId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameReviewComment
      withAdditionalParams:nil];
}

- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.reviewId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNamePhoto
      withAdditionalParams:@{@"detail1" : @"Comment"}];
}

@end
