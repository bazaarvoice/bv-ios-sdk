//
//  BVBaseUGCSubmission+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVBASEUGCSUBMISSION_PRIVATE_H
#define BVBASEUGCSUBMISSION_PRIVATE_H

#import "BVBaseUGCSubmission.h"
#import "BVPhotoSubmission.h"
#import "BVVideoSubmission.h"
#import "BVSubmission+Private.h"

typedef void (^BVBaseUGCSubmissionPhotoCompletion)(
    NSArray<NSString *> *__nonnull photoURLs,
    NSArray<NSString *> *__nonnull photoCaptions);

typedef void (^BVBaseUGCSubmissionVideoCompletion)(
    NSArray<NSString *> *__nonnull videoURLs,
    NSArray<NSString *> *__nonnull videoCaptions);

@interface BVBaseUGCSubmission <__covariant BVResponseType : BVSubmittedType *>
()

    @property(nonatomic, readonly,
              nonnull) NSMutableArray<BVPhotoSubmission *> *photos;
    @property(nonatomic, readonly,
              nonnull) NSMutableArray<BVVideoSubmission *> *videos;

+ (BVPhotoContentType)contentType;
- (void)asyncUploadPhotos:(BVBaseUGCSubmissionPhotoCompletion)success
                  failure:(ConversationsFailureHandler)failure;
- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent;

+ (BVVideoContentType)videoContentType;
- (void)asyncUploadVideo:(BVBaseUGCSubmissionVideoCompletion)success
                  failure:(ConversationsFailureHandler)failure;

@end

#endif /* BVBASEUGCSUBMISSION_PRIVATE_H */
