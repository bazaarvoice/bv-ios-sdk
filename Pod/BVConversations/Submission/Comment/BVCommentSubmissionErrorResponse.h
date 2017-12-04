//
//  BVCommentSubmissionErrorResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVSubmittedComment.h"

@interface BVCommentSubmissionErrorResponse : BVSubmissionErrorResponse

@property(nullable) BVSubmittedComment *comment;

@end
