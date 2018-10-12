//
//  ReviewSubmission.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmission.h"
#import "BVBaseUGCSubmission+Private.h"
#import "BVFeatureUsedEvent.h"
#import "BVReviewSubmissionErrorResponse.h"
#import "BVReviewSubmissionResponse.h"
#import "BVUploadableYouTubeVideo.h"

@interface BVReviewSubmission ()

@property NSUInteger rating;
@property(nonnull) NSString *reviewText;
@property(nonnull) NSString *reviewTitle;
@property(nonnull, readwrite) NSString *productId;

@property(nonnull) NSMutableDictionary *additionalFields;
@property(nonnull) NSMutableDictionary *contextDataValues;
@property(nonnull) NSMutableDictionary *ratingQuestions;
@property(nonnull) NSMutableDictionary *ratingSliders;
@property(nonnull) NSMutableDictionary *predefinedTags;
@property(nonnull) NSMutableDictionary *freeformTags;

@property(nonnull) NSMutableArray<BVUploadableYouTubeVideo *> *videos;

@end

@implementation BVReviewSubmission

+ (BVPhotoContentType)contentType {
  return BVPhotoContentTypeReview;
}

- (nonnull instancetype)initWithReviewTitle:(nonnull NSString *)reviewTitle
                                 reviewText:(nonnull NSString *)reviewText
                                     rating:(NSUInteger)rating
                                  productId:(nonnull NSString *)productId {
  if ((self = [super init])) {
    self.reviewTitle = reviewTitle;
    self.reviewText = reviewText;
    self.rating = rating;
    self.productId = productId;

    self.additionalFields = [NSMutableDictionary dictionary];
    self.contextDataValues = [NSMutableDictionary dictionary];
    self.ratingQuestions = [NSMutableDictionary dictionary];
    self.ratingSliders = [NSMutableDictionary dictionary];
    self.predefinedTags = [NSMutableDictionary dictionary];
    self.freeformTags = [NSMutableDictionary dictionary];
    self.videos = [NSMutableArray array];
  }
  return self;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#additional-field
- (void)addAdditionalField:(nonnull NSString *)fieldName
                     value:(nonnull NSString *)value {
  NSString *key = [NSString stringWithFormat:@"additionalfield_%@", fieldName];
  self.additionalFields[key] = value;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#context-data-question
- (void)addContextDataValueString:(nonnull NSString *)contextDataValueName
                            value:(nonnull NSString *)value {
  NSString *key =
      [NSString stringWithFormat:@"contextdatavalue_%@", contextDataValueName];
  self.contextDataValues[key] = value;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#context-data-question
- (void)addContextDataValueBool:(nonnull NSString *)contextDataValueName
                          value:(bool)value {
  NSString *key =
      [NSString stringWithFormat:@"contextdatavalue_%@", contextDataValueName];
  self.contextDataValues[key] = value ? @"true" : @"false";
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#rating-question---normal
- (void)addRatingQuestion:(nonnull NSString *)ratingQuestionName
                    value:(NSInteger)value {
  NSString *key = [NSString stringWithFormat:@"rating_%@", ratingQuestionName];
  NSString *valueAsString = [NSString stringWithFormat:@"%i", (int)value];
  self.ratingQuestions[key] = valueAsString;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#rating-question---slider
- (void)addRatingSlider:(nonnull NSString *)ratingQuestionName
                  value:(nonnull NSString *)value {
  NSString *key = [NSString stringWithFormat:@"rating_%@", ratingQuestionName];
  self.ratingSliders[key] = value;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#tags---tag-dimensions
- (void)addPredefinedTagDimension:(nonnull NSString *)tagQuestionId
                            tagId:(nonnull NSString *)tagId
                            value:(nonnull NSString *)value {
  NSString *key =
      [NSString stringWithFormat:@"tagid_%@/%@", tagQuestionId, tagId];
  self.predefinedTags[key] = value;
}

/// https://developer.bazaarvoice.com/apis/conversations/tutorials/field_types#tags---tag-dimensions
- (void)addFreeformTagDimension:(nonnull NSString *)tagQuestionId
                      tagNumber:(NSInteger)tagNumber
                          value:(nonnull NSString *)value {
  NSString *key =
      [NSString stringWithFormat:@"tag_%@_%i", tagQuestionId, (int)tagNumber];
  self.freeformTags[key] = value;
}

- (void)addVideoURL:(nonnull NSString *)url
        withCaption:(nullable NSString *)videoCaption {
  BVUploadableYouTubeVideo *video =
      [[BVUploadableYouTubeVideo alloc] initWithVideoURL:url
                                            videoCaption:videoCaption];
  [self.videos addObject:video];
}

- (nonnull NSString *)endpoint {
  return @"submitreview.json";
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];
  parameters[@"reviewtext"] = self.reviewText;
  parameters[@"title"] = self.reviewTitle;
  parameters[@"rating"] =
      [NSString stringWithFormat:@"%lu", (unsigned long)self.rating];
  parameters[@"productId"] = self.productId;

  if (self.isRecommended) {
    parameters[@"isrecommended"] =
        [self.isRecommended boolValue] == YES ? @"true" : @"false";
  }

  parameters[@"netpromotercomment"] = self.netPromoterComment;

  if (self.netPromoterScore) {
    parameters[@"netpromoterscore"] =
        [NSString stringWithFormat:@"%i", [self.netPromoterScore intValue]];
  }

  NSUInteger videoIndex = 1;
  for (BVUploadableYouTubeVideo *video in self.videos) {
    NSString *key = [NSString stringWithFormat:@"VideoUrl_%i", (int)videoIndex];
    parameters[key] = video.videoURL;

    if (video.videoCaption) {
      NSString *key =
          [NSString stringWithFormat:@"VideoCaption_%i", (int)videoIndex];
      parameters[key] = video.videoCaption;
    }

    videoIndex += 1;
  }

  for (NSString *key in self.additionalFields) {
    parameters[key] = self.additionalFields[key];
  }
  for (NSString *key in self.contextDataValues) {
    parameters[key] = self.contextDataValues[key];
  }
  for (NSString *key in self.ratingQuestions) {
    parameters[key] = self.ratingQuestions[key];
  }
  for (NSString *key in self.ratingSliders) {
    parameters[key] = self.ratingSliders[key];
  }
  for (NSString *key in self.predefinedTags) {
    parameters[key] = self.predefinedTags[key];
  }
  for (NSString *key in self.freeformTags) {
    parameters[key] = self.freeformTags[key];
  }

  return parameters;
}

- (nonnull BVSubmissionResponse *)createResponse:(nonnull NSDictionary *)raw {
  return [[BVReviewSubmissionResponse alloc] initWithApiResponse:raw];
}

- (nonnull BVSubmissionErrorResponse *)createErrorResponse:
    (nonnull NSDictionary *)raw {
  return [[BVReviewSubmissionErrorResponse alloc] initWithApiResponse:raw];
}

- (nullable id<BVAnalyticEvent>)trackEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.productId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNameWriteReview
      withAdditionalParams:nil];
}

- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent {
  return [[BVFeatureUsedEvent alloc]
         initWithProductId:self.productId
                 withBrand:nil
           withProductType:BVPixelProductTypeConversationsReviews
             withEventName:BVPixelFeatureUsedEventNamePhoto
      withAdditionalParams:nil];
}

@end
