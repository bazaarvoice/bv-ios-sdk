//
//  BVBaseUGCSubmission.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission+Private.h"
#import "BVLogger+Private.h"
#import "BVPhotoSubmissionResponse.h"
#import "BVVideoSubmissionResponse.h"
#import "BVPixel.h"
#import <UIKit/UIKit.h>

@interface BVBaseUGCSubmission ()
@property(nonatomic, strong, readwrite, nullable)
    NSMutableArray<BVPhotoSubmission *> *internalPhotos;
@property(nonatomic, strong, readwrite, nullable)
    NSArray<NSString *> *photoURLs;
@property(nonatomic, strong, readwrite, nullable)
    NSArray<NSString *> *photoCaptions;
@property(nonatomic, strong, readwrite, nullable)
    NSMutableArray<BVVideoSubmission     *> *internalVideos;
@property(nonatomic, strong, readwrite, nullable)
    NSArray<NSString *> *videoURLs;
@property(nonatomic, strong, readwrite, nullable)
    NSArray<NSString *> *videoCaptions;
@property(nonatomic, strong, nonnull) dispatch_queue_t serialUploadQueue;
@property(nonatomic, strong, nonnull) dispatch_queue_t concurrentUploadQueue;
@end

@implementation BVBaseUGCSubmission

+ (BVPhotoContentType)contentType {
  return BVPhotoContentTypeAnswer;
}

- (NSMutableArray<BVPhotoSubmission *> *)photos {
  return self.internalPhotos;
}

+ (BVVideoContentType)videoContentType {
  return BVVideoContentTypeReview;
}

- (NSMutableArray<BVVideoSubmission *> *)videos {
  return self.internalVideos;
}

- (nonnull instancetype)init {
  if ((self = [super init])) {
    self.internalPhotos = [NSMutableArray array];
    self.internalVideos = [NSMutableArray array];
    self.serialUploadQueue =
        dispatch_queue_create("com.bazaarvoice.BVBaseUGCSubmission.uploadQueue",
                              DISPATCH_QUEUE_SERIAL);
    self.concurrentUploadQueue =
        dispatch_queue_create("com.bazaarvoice.BVBaseUGCSubmission.uploadQueue",
                              DISPATCH_QUEUE_CONCURRENT);
  }
  return self;
}

- (void)addPhoto:(nonnull UIImage *)image
    withPhotoCaption:(nullable NSString *)photoCaption {
  BVPhotoSubmission *photo =
      [[BVPhotoSubmission alloc] initWithPhoto:image
                                  photoCaption:photoCaption
                              photoContentType:[[self class] contentType]];
  [self.internalPhotos addObject:photo];
}

- (void)asyncUploadPhotos:(BVBaseUGCSubmissionPhotoCompletion)success
                  failure:(ConversationsFailureHandler)failure {
  /// If we got nothing, then just bail
  if (0 == self.photos.count) {
    success(@[], @[]);
    return;
  }

  NSMutableArray<NSString *> *photoURLs = [NSMutableArray array];
  NSMutableArray<NSString *> *photoCaptions = [NSMutableArray array];
  NSMutableArray<NSError *> *photoUploadErrors = [NSMutableArray array];

  dispatch_group_t uploadGroup = dispatch_group_create();

  for (BVPhotoSubmission *photo in self.photos) {
    /// We enter before the dispatch to avoid any whacky race conditions such as
    /// these blocks not being serviced until the final wait block is issued.
    dispatch_group_enter(uploadGroup);

    /// Enqueue the photo upload request
    dispatch_async(self.concurrentUploadQueue, ^{

        [photo upload:^(NSString *_Nonnull photoURL,
                        NSString *_Nonnull photoCaption) {
            dispatch_async(self.serialUploadQueue, ^{
                
                if (photoURL && photoCaption) {
                    [photoURLs addObject:photoURL];
                    [photoCaptions addObject:photo.photoCaption];
                }
                /// We leave if success
                dispatch_group_leave(uploadGroup);
            });
      }
          failure:^(NSArray<NSError *> *__nonnull errors) {
            dispatch_async(self.serialUploadQueue, ^{
                [photoUploadErrors addObjectsFromArray:errors];
                
                /// We leave if success
                dispatch_group_leave(uploadGroup);
            });
          }];
    });
  }

  dispatch_async(self.concurrentUploadQueue, ^{
    /// Wait until all enqueued operations have completed
    (void)dispatch_group_wait(uploadGroup, DISPATCH_TIME_FOREVER);

    /// Call back on the serial queue just to be on the safe side, i.e., if we
    /// make code changes in the future that may introduce race conditions.
    dispatch_async(self.serialUploadQueue, ^{
      if (0 < photoUploadErrors.count) {
        failure(photoUploadErrors);
        return;
      }
      success(photoURLs, photoCaptions);
    });
  });
}

- (void)submit:(void (^__nonnull)(
                   BVSubmissionResponse<BVSubmittedType *> *__nonnull))success
       failure:(nonnull ConversationsFailureHandler)failure {

  /// If they call it multiple times, oh well, we'll end up uploading more
  /// photos but at least everything should succeed.
  self.photoURLs = nil;
  self.photoCaptions = nil;
    self.videoURLs = nil;
    self.videoCaptions = nil;

  if (BVSubmissionActionPreview == self.action || BVSubmissionActionForm == self.action) {
    NSString *warningLog =
        [NSString stringWithFormat:
                      @"Submitting a '%@' with action set to "
                      @"`BVSubmissionActionPreview`/`BVSubmissionActionForm` will not actially submit! "
                      @"Set to `BVSubmissionActionSubmit` for real submission.",
                      NSStringFromClass([self class])];
    BVLogWarning(warningLog, BV_PRODUCT_CONVERSATIONS);
    [super submit:success failure:failure];
    return;
  }

  /// Swap to preview first
  self.action = BVSubmissionActionPreview;
  [super submit:^(BVSubmissionResponse<BVSubmittedType *> *__nonnull response) {

    /// Swap back to submit to actual send
    self.action = BVSubmissionActionSubmit;

    /// upload photos before submitting comments (prr only)
    [self asyncUploadPhotos:^(NSArray<NSString *> *_Nonnull photoURLs,
                              NSArray<NSString *> *_Nonnull photoCaptions) {

      /// Squirrel away photo meta-data
      self.photoURLs = photoURLs;
      self.photoCaptions = photoCaptions;

      /// Do the actual submission
      [super submit:success failure:failure];

      /// Send off analytics if need be
      [photoURLs
          enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                       BOOL *_Nonnull stop) {
            /// Queue one event for each photo uploaded.
            id<BVAnalyticEvent> photoUploadEvent = [self trackMediaUploadEvent];
            if (photoUploadEvent) {
              [BVPixel trackEvent:photoUploadEvent];
            }
          }];
    }
        failure:^(NSArray<NSError *> *_Nonnull errors) {
          [self sendErrors:errors failureCallback:failure];
        }];
      
      /// upload videos before submitting comments (prr only)
        [self asyncUploadVideo:^(NSArray<NSString *> * _Nonnull videoURLs,
                                 NSArray<NSString *> * _Nonnull videoCaptions) {
            /// Squirrel away video meta-data
            self.videoURLs = videoURLs;
            self.videoCaptions = videoCaptions;
            
            /// Do the actual submission
            [super submit:success failure:failure];
            
            /// Send off analytics if need be
            [videoURLs
                enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                             BOOL *_Nonnull stop) {
                  /// Queue one event for each photo uploaded.
                  id<BVAnalyticEvent> videoUploadEvent = [self trackMediaUploadEvent];
                  if (videoUploadEvent) {
                    [BVPixel trackEvent:videoUploadEvent];
                  }
                }];

        } failure:^(NSArray<NSError *> * _Nonnull errors) {
            [self sendErrors:errors failureCallback:failure];
        }];

  }
      failure:^(NSArray<NSError *> *__nonnull errors) {
        [self sendErrors:errors failureCallback:failure];
      }];
}

- (nonnull NSDictionary *)createSubmissionParameters {
  NSMutableDictionary *parameters = [NSMutableDictionary
      dictionaryWithDictionary:[super createSubmissionParameters]];

  if (self.action != BVSubmissionActionForm) {
    parameters[@"action"] = [BVSubmissionActionUtil toString:self.action];
  }

  parameters[@"campaignid"] = self.campaignId;
  parameters[@"locale"] = self.locale;

  parameters[@"hostedauthentication_authenticationemail"] =
      self.hostedAuthenticationEmail;
  parameters[@"hostedauthentication_callbackurl"] =
      self.hostedAuthenticationCallback;
  parameters[@"fp"] = self.fingerPrint;
  parameters[@"user"] = self.user;
  parameters[@"usernickname"] = self.userNickname;
  parameters[@"useremail"] = self.userEmail;
  parameters[@"userid"] = self.userId;
  parameters[@"userlocation"] = self.userLocation;

  if (self.sendEmailAlertWhenPublished) {
    parameters[@"sendemailalertwhenpublished"] =
        [self.sendEmailAlertWhenPublished boolValue] ? @"true" : @"false";
  }

  if (self.agreedToTermsAndConditions) {
    parameters[@"agreedtotermsandconditions"] =
        [self.agreedToTermsAndConditions boolValue] ? @"true" : @"false";
  }

  if (self.sendEmailAlertWhenCommented) {
    parameters[@"sendemailalertwhencommented"] =
        [self.sendEmailAlertWhenCommented boolValue] ? @"true" : @"false";
  }

  if (self.photoURLs && self.photoCaptions &&
      self.photos.count == self.photoURLs.count) {
    [self.photoURLs
        enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                     BOOL *_Nonnull stop) {
          NSString *key =
              [NSString stringWithFormat:@"photourl_%lu", (unsigned long)idx];
          parameters[key] = obj;
        }];

    [self.photoCaptions enumerateObjectsUsingBlock:^(NSString *_Nonnull obj,
                                                     NSUInteger idx,
                                                     BOOL *_Nonnull stop) {
      NSString *key =
          [NSString stringWithFormat:@"photocaption_%lu", (unsigned long)idx];
      parameters[key] = obj;
    }];
  }
    
    if (self.videoURLs && self.videoCaptions &&
        self.videos.count == self.videoURLs.count) {
      [self.videoURLs
          enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                       BOOL *_Nonnull stop) {
            NSString *key =
                [NSString stringWithFormat:@"videourl_%lu", (unsigned long)idx];
            parameters[key] = obj;
          }];

      [self.photoCaptions enumerateObjectsUsingBlock:^(NSString *_Nonnull obj,
                                                       NSUInteger idx,
                                                       BOOL *_Nonnull stop) {
        NSString *key =
            [NSString stringWithFormat:@"videocaption_%lu", (unsigned long)idx];
        parameters[key] = obj;
      }];
    }

  return parameters;
}

- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent {
  NSAssert(NO, @"trackMediaUploadEvent method should be overridden");
  return nil;
}

- (void)addVideo:(nonnull NSURL *)videoPath withVideoCaption:(nullable NSString *)videoCaption uploadVideo:(BOOL)uploadVideo {
    
    BVVideoSubmission *video = [[BVVideoSubmission alloc] initWithVideo:videoPath.absoluteString
                                                           videoCaption:videoCaption
                                                            uploadVideo:uploadVideo
                                                       videoContentType:BVVideoContentTypeReview];
    
  [self.internalVideos addObject:video];
}

- (void)asyncUploadVideo:(BVBaseUGCSubmissionVideoCompletion)success
                 failure:(ConversationsFailureHandler)failure {
    /// If we got nothing, then just bail
    if (0 == self.videos.count) {
        success(@[], @[]);
        return;
    }
    
    NSMutableArray<NSString *> *videoURLs = [NSMutableArray array];
    NSMutableArray<NSString *> *videoCaptions = [NSMutableArray array];
    NSMutableArray<NSError *> *videoUploadErrors = [NSMutableArray array];
    
    dispatch_group_t uploadGroup = dispatch_group_create();
    
    for (BVVideoSubmission *video in self.videos) {
        /// We enter before the dispatch to avoid any whacky race conditions such as
        /// these blocks not being serviced until the final wait block is issued.
        if (video.uploadVideo) {
            dispatch_group_enter(uploadGroup);
            
            /// Enqueue the photo upload request
            dispatch_async(self.concurrentUploadQueue, ^{
                
                [video upload:^(NSString * _Nonnull videoURL,
                                NSString * _Nonnull videoCaption) {
                    dispatch_async(self.serialUploadQueue, ^{
                        if (videoURL && videoCaption) {
                            [videoURLs addObject:videoURL];
                            [videoCaptions addObject:videoCaption];
                        }
                        /// We leave if success
                        dispatch_group_leave(uploadGroup);
                    });
                } failure:^(NSArray<NSError *> * _Nonnull errors) {
                    dispatch_async(self.serialUploadQueue, ^{
                        [videoUploadErrors addObjectsFromArray:errors];
                        
                        /// We leave if success
                        dispatch_group_leave(uploadGroup);
                    });
                }];
            });
        } else {
            [videoURLs addObject:video.video];
            [videoCaptions addObject:video.videoCaption];
        }
    }

  dispatch_async(self.concurrentUploadQueue, ^{
    /// Wait until all enqueued operations have completed
    (void)dispatch_group_wait(uploadGroup, DISPATCH_TIME_FOREVER);

    /// Call back on the serial queue just to be on the safe side, i.e., if we
    /// make code changes in the future that may introduce race conditions.
    dispatch_async(self.serialUploadQueue, ^{
      if (0 < videoUploadErrors.count) {
        failure(videoUploadErrors);
        return;
      }
      success(videoURLs, videoCaptions);
    });
  });
}

@end
