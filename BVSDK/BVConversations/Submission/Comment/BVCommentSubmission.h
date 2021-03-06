//
//  BVCommentSubmission.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBaseUGCSubmission.h"
#import "BVSubmittedComment.h"

@interface BVCommentSubmission : BVBaseUGCSubmission <BVSubmittedComment *>

/// Initialize a request object to add a review comment. Initialize the request
/// with the supplied initializer, then add the additional parameters required
/// by your API key. See also the Bazaarvoice Developer Reference:
/// https://developer.bazaarvoice.com/conversations-api/reference/v5.4/comments/comment-submission
///
/// @param reviewId The review ID to add the comment to
/// @param commentText The user supplied text
/// @return initialized BVCommentSubmission parameter
- (nonnull instancetype)initWithReviewId:(nonnull NSString *)reviewId
                         withCommentText:(nonnull NSString *)commentText;
- (nonnull instancetype)__unavailable init;

@property(nonnull, readonly) NSString *reviewId;
@property(nonnull, readonly) NSString *commentText;
@property(nonnull) NSString *commentTitle;

@end
