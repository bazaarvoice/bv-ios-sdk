//
//  BVUASSubmissionResponse.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVSubmissionResponse.h"

@class BVSubmittedUAS;
@interface BVUASSubmissionResponse : BVSubmissionResponse

@property (readonly) BVSubmittedUAS *_Nullable userAuthenticationString;

@end
