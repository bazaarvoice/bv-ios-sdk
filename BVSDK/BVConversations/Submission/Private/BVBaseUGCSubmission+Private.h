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

typedef void (^BVBaseUGCSubmissionMediaCompletion)(
    NSArray<NSString *> *__nonnull photoURLs,
    NSArray<NSString *> *__nonnull photoCaptions,
    NSArray<NSString *> *__nonnull videoURLs,
    NSArray<NSString *> *__nonnull videoCaptions);

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
+ (BVVideoContentType)videoContentType;

- (void)asyncMediaUpload:(BVBaseUGCSubmissionMediaCompletion _Nullable )success
              failure:(ConversationsFailureHandler _Nullable )failure;
- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent;

@end

#endif /* BVBASEUGCSUBMISSION_PRIVATE_H */
