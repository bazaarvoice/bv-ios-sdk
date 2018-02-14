//
//  BVUASSubmission.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVConversationsRequest.h"
#import <Foundation/Foundation.h>

@class BVUASSubmissionResponse;

typedef void (^UASSubmissionCompletion)(
    BVUASSubmissionResponse *__nonnull response);

/**
 Class to use to submit an user authentication string request with the
 bv_authtoken to the Bazaarvoice managed authentication platform.

 For a description of the authentication process you can view the docs:
 https://developer.bazaarvoice.com/conversations-api/tutorials/submission/authentication/bv-mastered#step-4:-user-authentication

 @availability 5.4.0 and later
 */
@interface BVUASSubmission : BVBaseUGCSubmission

/**
 Create a new BVUASSubmissionResponse.

 @param bvAuthToken    The bvAuthToken representing the
 hosted authenticating user.
 */
- (nonnull instancetype)initWithBvAuthToken:(nonnull NSString *)bvAuthToken;
- (nonnull instancetype)__unavailable init;

/**
 Submit this answer to the Bazaarvoice platform. If the `action` of this object
 is set to `BVSubmissionActionPreview` then the submission will NOT actually
 take place.

 A submission can fail for many reasons, and is dependent on your submission
 configuration.

 @param success    The success block is called when a successful submission
 occurs.
 @param failure    The failure block is called when an unsuccessful submission
 occurs. This could be for a number of reasons: network failures, submission
 parameters invalid, or server errors occur.
 */
- (void)submit:(nonnull UASSubmissionCompletion)success
       failure:(nonnull ConversationsFailureHandler)failure;

@property(nonnull, readonly) NSString *bvAuthToken;
@property BVSubmissionAction action UNAVAILABLE_ATTRIBUTE;

@end
