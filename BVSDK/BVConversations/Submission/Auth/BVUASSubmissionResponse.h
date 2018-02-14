//
//  BVUASSubmissionResponse.h
//  Conversations
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionResponse.h"
#import <Foundation/Foundation.h>

@class BVSubmittedUAS;
@interface BVUASSubmissionResponse : BVSubmissionResponse

@property(nullable, readonly) BVSubmittedUAS *userAuthenticationString;

@end
