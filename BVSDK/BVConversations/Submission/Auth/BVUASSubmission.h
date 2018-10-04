//
//  BVUASSubmission.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmission.h"
#import "BVSubmittedUAS.h"
#import <Foundation/Foundation.h>

/**
 Class to use to submit an user authentication string request with the
 bv_authtoken to the Bazaarvoice managed authentication platform.

 For a description of the authentication process you can view the docs:
 https://developer.bazaarvoice.com/conversations-api/tutorials/submission/authentication/bv-mastered#step-4:-user-authentication

 @availability 5.4.0 and later
 */
@interface BVUASSubmission : BVSubmission <BVSubmittedUAS *>

/**
 Create a new BVUASSubmissionResponse.

 @param bvAuthToken    The bvAuthToken representing the
 hosted authenticating user.
 */
- (nonnull instancetype)initWithBvAuthToken:(nonnull NSString *)bvAuthToken;
- (nonnull instancetype)__unavailable init;

@property(nonnull, readonly) NSString *bvAuthToken;

@end
