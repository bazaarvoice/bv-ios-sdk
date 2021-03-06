//
//  BVAnswerSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedAnswer.h"
#import <Foundation/Foundation.h>

/// Successful answer submission response.
@interface BVAnswerSubmissionResponse
    : BVSubmissionResponse <BVSubmittedAnswer *>
@end
