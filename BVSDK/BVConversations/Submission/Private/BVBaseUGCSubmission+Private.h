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
#import "BVSubmission+Private.h"

typedef void (^BVBaseUGCSubmissionPhotoCompletion)(
    NSArray<NSString *> *__nonnull photoURLs,
    NSArray<NSString *> *__nonnull photoCaptions);

@interface BVBaseUGCSubmission <__covariant BVResponseType : BVSubmittedType *>
()

    @property(nonatomic, readonly,
              nonnull) NSMutableArray<BVPhotoSubmission *> *photos;

+ (BVPhotoContentType)contentType;
- (void)asyncUploadPhotos:(BVBaseUGCSubmissionPhotoCompletion)success
                  failure:(ConversationsFailureHandler)failure;
- (nullable id<BVAnalyticEvent>)trackMediaUploadEvent;

@end

#endif /* BVBASEUGCSUBMISSION_PRIVATE_H */
