//
//  BVSubmission.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversations.h"
#import "BVSubmissionResponse.h"
#import "BVSubmittedType.h"
#import <Foundation/Foundation.h>

@interface BVSubmission <__covariant BVResponseType : BVSubmittedType *>: NSObject

/// This method adds extra user provided form parameters to a
/// submission request, and will be urlencoded.
/// @param parameter        The user-provded key.
/// @param value            The user-provided value.
- (void)addCustomSubmissionParameter:(nonnull NSString *)parameter
                           withValue:(nonnull NSString *)value;

/// Submit this request to the Bazaarvoice platform.
///
/// A submission can fail for many reasons, and is dependent on your submission
/// configuration.
///
/// @param success    The success block is called when a successful submission
/// occurs.
/// @param failure    The failure block is called when an unsuccessful
/// submission occurs. This could be for a number of reasons: network failures,
/// submission parameters invalid, or server errors occur.
- (void)submit:(void (^__nonnull)(
                   BVSubmissionResponse<BVResponseType> *__nonnull))success
       failure:(nonnull ConversationsFailureHandler)failure;

@end
