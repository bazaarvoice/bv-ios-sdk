//
//  BVUASSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import "BVSubmittedUAS.h"
#import <Foundation/Foundation.h>

@interface BVUASSubmissionResponse : BVSubmissionResponse <BVSubmittedUAS *>
@end
