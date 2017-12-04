//
//  BVCommentSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedComment.h"

@interface BVCommentSubmissionResponse : BVSubmissionResponse

@property(nullable) BVSubmittedComment *comment;

@end
