//
//  BVVideoSubmission.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVSubmission.h"
#import "BVSubmittedVideo.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BVVideoContentType) {
  BVVideoContentTypeReview
};

@interface BVVideoSubmission: BVSubmission <BVSubmittedVideo *>

typedef void (^BVVideoSubmissionUploadCompletion)(
                                                  NSString *__nonnull videoURL,
                                                  NSString *__nonnull videoCaption);

@property(nonnull, readonly) NSString *video;
@property(nonnull, readonly) NSString *videoCaption;
@property(readwrite) BOOL uploadVideo;
@property(readonly) BVVideoContentType videoContentType;
@property(readwrite) NSUInteger
    maxVideoBytes; // Set by BVVideoSubmission itself, but is here for testing

- (nonnull instancetype)initWithVideo:(nonnull NSString *)video
                    videoCaption:(nullable NSString *)videoCaption
                    uploadVideo:(BOOL)uploadVideo
                    videoContentType:(BVVideoContentType)videoContentType;
- (nonnull instancetype)__unavailable init;

- (void)upload:(BVVideoSubmissionUploadCompletion)success
failure:(ConversationsFailureHandler)failure;

@end
