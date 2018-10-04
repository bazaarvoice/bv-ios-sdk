//
//  BVSubmission+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVSUBMISSION_PRIVATE_H
#define BVSUBMISSION_PRIVATE_H

#import "BVAnalyticEvent.h"
#import "BVSubmission.h"
#import "BVSubmissionErrorResponse+Private.h"
#import "BVSubmissionResponse.h"

@interface BVSubmission <__covariant BVResponseType : BVSubmittedType *>
()

    @property(nonatomic, readonly, nonnull) NSString *conversationsKey;

+ (nonnull NSString *)commonEndpoint;

- (void)sendError:(nonnull NSError *)error
    failureCallback:(nonnull ConversationsFailureHandler)failure;
- (void)sendErrors:(nonnull NSArray<NSError *> *)errors
    failureCallback:(nonnull ConversationsFailureHandler)failure;
- (nonnull NSData *)transformToPostBody:(nonnull NSDictionary *)parameters;
- (void)sendResponse:(nonnull BVSubmissionResponse<BVSubmittedType *> *)response
     successCallback:
         (void (^__nonnull)(BVSubmissionResponse<BVSubmittedType *> *__nonnull))
             success;

- (nonnull NSString *)endpoint;
- (nonnull NSURLRequest *)generateRequest;
- (nonnull NSDictionary *)createSubmissionParameters;
- (nonnull BVSubmissionResponse<BVResponseType> *)createResponse:
    (nonnull NSDictionary *)raw;
- (nonnull BVSubmissionErrorResponse<BVResponseType> *)createErrorResponse:
    (nonnull NSDictionary *)raw;
- (nullable id<BVAnalyticEvent>)trackEvent;

@end

#endif /* BVSUBMISSION_PRIVATE_H */
