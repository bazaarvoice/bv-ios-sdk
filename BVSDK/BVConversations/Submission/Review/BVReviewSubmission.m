//
//  ReviewSubmission.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVReviewSubmission.h"
#import "BVNetworkingManager.h"
#import "BVReviewSubmissionErrorResponse.h"
#import "BVSDKConfiguration.h"
#import "BVSDKManager.h"

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

@property BOOL failureCalled;
@end

@implementation BVReviewSubmission

- (nonnull instancetype)initWithReviewTitle:(nonnull NSString *)reviewTitle
                                 reviewText:(nonnull NSString *)reviewText
                                     rating:(NSUInteger)rating
                                  productId:(nonnull NSString *)productId {
  self = [super init];
  if (self) {
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

- (void)submit:(nonnull ReviewSubmissionCompletion)success
       failure:(nonnull ConversationsFailureHandler)failure {
  if (self.action == BVSubmissionActionPreview) {
    [[BVLogger sharedLogger]
        warning:@"Submitting a 'BVReviewSubmission' with action set to "
                @"`BVSubmissionActionPreview` will not actially submit "
                @"the review! Set to `BVSubmissionActionSubmit` for real "
                @"submission."];
    [self submitPreview:success failure:failure];
  } else {
    [self submitPreview:^(BVReviewSubmissionResponse *__nonnull response) {
      //[BVConversationsAnalyticsUtil
      // queueAnalyticsEventForReviewSubmission:self];
      [self submitForReal:success failure:failure];
    }
        failure:^(NSArray<NSError *> *__nonnull errors) {
          [[BVLogger sharedLogger] printErrors:errors];
          failure(errors);
        }];
  }
}

- (void)submitPreview:(ReviewSubmissionCompletion)success
              failure:(ConversationsFailureHandler)failure {
  [self submitReviewWithPhotoUrls:BVSubmissionActionPreview
                        photoUrls:@[]
                    photoCaptions:@[]
                          success:success
                          failure:failure];
}

- (void)submitForReal:(ReviewSubmissionCompletion)success
              failure:(ConversationsFailureHandler)failure {
  if ([self.photos count] == 0) {
    [self submitReviewWithPhotoUrls:BVSubmissionActionSubmit
                          photoUrls:@[]
                      photoCaptions:@[]
                            success:success
                            failure:failure];
    return;
  }

  // upload photos before submitting content
  NSMutableArray<NSString *> *photoUrls = [NSMutableArray array];
  NSMutableArray<NSString *> *photoCaptions = [NSMutableArray array];

  for (BVUploadablePhoto *photo in self.photos) {
    [photo uploadForContentType:BVPhotoContentTypeReview
        success:^(NSString *__nonnull photoUrl) {

          // Queue one event for each photo uploaded.
          BVFeatureUsedEvent *photoUploadEvent = [[BVFeatureUsedEvent alloc]
                 initWithProductId:self.productId
                         withBrand:nil
                   withProductType:BVPixelProductTypeConversationsReviews
                     withEventName:BVPixelFeatureUsedEventNamePhoto
              withAdditionalParams:nil];

          [BVPixel trackEvent:photoUploadEvent];

          [photoUrls addObject:photoUrl];
          [photoCaptions addObject:photo.photoCaption];

          // all photos uploaded! submit content
          if ([photoUrls count] == [self.photos count]) {
            [self submitReviewWithPhotoUrls:BVSubmissionActionSubmit
                                  photoUrls:photoUrls
                              photoCaptions:photoCaptions
                                    success:success
                                    failure:failure];
          }

        }
        failure:^(NSArray<NSError *> *__nonnull errors) {
          if (!self.failureCalled) {
            self.failureCalled = true; // only call failure block once, if
                                       // multiple photos failed.
            [[BVLogger sharedLogger] printErrors:errors];
            failure(errors);
          }

        }];
  }
}

- (void)submitReviewWithPhotoUrls:(BVSubmissionAction)action
                        photoUrls:(nonnull NSArray<NSString *> *)photoUrls
                    photoCaptions:(nonnull NSArray<NSString *> *)photoCaptions
                          success:(nonnull ReviewSubmissionCompletion)success
                          failure:(nonnull ConversationsFailureHandler)failure {
  NSDictionary *parameters = [self createSubmissionParameters:action
                                                    photoUrls:photoUrls
                                                photoCaptions:photoCaptions];
  NSData *postBody = [self transformToPostBody:parameters];

  NSString *urlString =
      [NSString stringWithFormat:@"%@submitreview.json",
                                 [BVConversationsRequest commonEndpoint]];
  NSURL *url = [NSURL URLWithString:urlString];

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:postBody];

  [[BVLogger sharedLogger]
      verbose:[NSString stringWithFormat:@"POST: %@\n with BODY: %@", urlString,
                                         parameters]];

  NSURLSession *session = nil;
  id<BVURLSessionDelegate> sessionDelegate =
      [BVSDKManager sharedManager].urlSessionDelegate;
  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector(URLSessionForBVObject:)]) {
    session = [sessionDelegate URLSessionForBVObject:self];
  }

  session = session ?: [BVNetworkingManager sharedManager].bvNetworkingSession;

  NSURLSessionDataTask *postDataTask = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response,
                            NSError *httpError) {

          @try {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)
                response; // This dataTask is used with only HTTP requests.
            NSInteger statusCode = httpResponse.statusCode;
            NSError *jsonParsingError;
            NSDictionary *json =
                [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:&jsonParsingError];
            BVReviewSubmissionErrorResponse *errorResponse =
                [[BVReviewSubmissionErrorResponse alloc]
                    initWithApiResponse:json]; // fails gracefully

            [[BVLogger sharedLogger]
                verbose:[NSString stringWithFormat:@"RESPONSE: %@ (%ld)", json,
                                                   (long)statusCode]];

            if (httpError) {
              // network error was generated
              [[BVLogger sharedLogger] printError:httpError];
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(@[ httpError ]);
              });
            } else if (statusCode >= 300) {
              // HTTP status code indicates failure
              NSError *statusError =
                  [NSError errorWithDomain:BVErrDomain
                                      code:BV_ERROR_NETWORK_FAILED
                                  userInfo:@{
                                    NSLocalizedDescriptionKey :
                                        @"Review upload failed."
                                  }];
              [[BVLogger sharedLogger] printError:statusError];
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(@[ statusError ]);
              });
            } else if (jsonParsingError) {
              // json parsing failed
              [[BVLogger sharedLogger] printError:jsonParsingError];
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(@[ jsonParsingError ]);
              });
            } else if (errorResponse) {
              // api returned successfully, but has bazaarvoice-specific
              // errors. Example: 'invalid api key'
              NSArray<NSError *> *errors = [errorResponse toNSErrors];
              [[BVLogger sharedLogger] printErrors:errors];
              dispatch_async(dispatch_get_main_queue(), ^{
                failure(errors);
              });
            } else {
              // success!

              // Fire event now that we've confirmed the event was
              // successfully uploaded.
              BVFeatureUsedEvent *writeReviewEvent = [[BVFeatureUsedEvent alloc]
                     initWithProductId:self.productId
                             withBrand:nil
                       withProductType:BVPixelProductTypeConversationsReviews
                         withEventName:BVPixelFeatureUsedEventNameWriteReview
                  withAdditionalParams:nil];

              [BVPixel trackEvent:writeReviewEvent];

              BVReviewSubmissionResponse *response =
                  [[BVReviewSubmissionResponse alloc] initWithApiResponse:json];
              dispatch_async(dispatch_get_main_queue(), ^{
                success(response);
              });
            }

          } @catch (NSException *exception) {
            NSError *unexpectedError =
                [NSError errorWithDomain:BVErrDomain
                                    code:BV_ERROR_UNKNOWN
                                userInfo:@{
                                  NSLocalizedDescriptionKey :
                                      @"An unknown parsing error occurred."
                                }];
            [[BVLogger sharedLogger] printError:unexpectedError];
            dispatch_async(dispatch_get_main_queue(), ^{
              failure(@[ unexpectedError ]);
            });
          }

        }];

  // start uploading review
  [postDataTask resume];

  if (sessionDelegate &&
      [sessionDelegate respondsToSelector:@selector
                       (URLSessionTask:fromBVObject:withURLSession:)]) {
    [sessionDelegate URLSessionTask:postDataTask
                       fromBVObject:self
                     withURLSession:session];
  }
}

- (nonnull NSDictionary *)
createSubmissionParameters:(BVSubmissionAction)action
                 photoUrls:(nonnull NSArray<NSString *> *)photoUrls
             photoCaptions:(nonnull NSArray<NSString *> *)photoCaptions {
  NSMutableDictionary *parameters =
      [NSMutableDictionary dictionaryWithDictionary:@{
        @"apiversion" : @"5.4",
        @"reviewtext" : self.reviewText,
        @"title" : self.reviewTitle,
        @"rating" :
            [NSString stringWithFormat:@"%lu", (unsigned long)self.rating],
        @"productId" : self.productId
      }];

  parameters[@"passkey"] = [self getPasskey];
  parameters[@"action"] = [BVSubmissionActionUtil toString:action];

  parameters[@"campaignid"] = self.campaignId;
  parameters[@"locale"] = self.locale;

  if (self.sendEmailAlertWhenCommented) {
    parameters[@"sendemailalertwhencommented"] =
        [self.sendEmailAlertWhenCommented boolValue] ? @"true" : @"false";
  }

  if (self.sendEmailAlertWhenPublished) {
    parameters[@"sendemailalertwhenpublished"] =
        [self.sendEmailAlertWhenPublished boolValue] ? @"true" : @"false";
  }

  if (self.agreedToTermsAndConditions) {
    parameters[@"agreedtotermsandconditions"] =
        [self.agreedToTermsAndConditions boolValue] ? @"true" : @"false";
  }

  parameters[@"hostedauthentication_authenticationemail"] =
      self.hostedAuthenticationEmail;
  parameters[@"hostedauthentication_callbackurl"] =
      self.hostedAuthenticationCallback;
  parameters[@"netpromotercomment"] = self.netPromoterComment;

  if (self.netPromoterScore) {
    parameters[@"netpromoterscore"] =
        [NSString stringWithFormat:@"%i", [self.netPromoterScore intValue]];
  }

  parameters[@"fp"] = self.fingerPrint;

  if (self.isRecommended != nil) {
    parameters[@"isrecommended"] =
        [self.isRecommended boolValue] == YES ? @"true" : @"false";
  }

  parameters[@"user"] = self.user;
  parameters[@"usernickname"] = self.userNickname;
  parameters[@"useremail"] = self.userEmail;
  parameters[@"userid"] = self.userId;
  parameters[@"userlocation"] = self.userLocation;

  NSUInteger photoIndex = 0;
  for (NSString *url in photoUrls) {
    NSString *key = [NSString stringWithFormat:@"photourl_%i", (int)photoIndex];
    parameters[key] = url;
    photoIndex += 1;
  }

  NSUInteger captionIndex = 0;
  for (NSString *caption in photoCaptions) {
    NSString *key =
        [NSString stringWithFormat:@"photocaption_%i", (int)captionIndex];
    parameters[key] = caption;
    captionIndex += 1;
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
  for (BVStringKeyValuePair *keyValuePair in self.customFormPairs) {
    NSString *key = [keyValuePair key];
    NSString *value = [keyValuePair value];
    parameters[key] = value;
  }

  return parameters;
}

- (nonnull NSString *)getPasskey {
  return [BVSDKManager sharedManager].configuration.apiKeyConversations;
}

- (void)addVideoURL:(nonnull NSString *)url
        withCaption:(nullable NSString *)videoCaption {
  BVUploadableYouTubeVideo *video =
      [[BVUploadableYouTubeVideo alloc] initWithVideoURL:url
                                            videoCaption:videoCaption];
  [self.videos addObject:video];
}
@end
