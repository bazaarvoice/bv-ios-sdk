//
//  BVSubmissionErrorResponse+Private.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#ifndef BVSUBMISSIONERRORRRESPONSE_PRIVATE_H
#define BVSUBMISSIONERRORRRESPONSE_PRIVATE_H

#import "BVSubmissionErrorResponse.h"

@class BVFieldError;
@interface BVSubmissionErrorResponse ()

@property(nonnull) NSArray<BVFieldError *> *fieldErrors;

@end

#endif /* BVSUBMISSIONERRORRRESPONSE_PRIVATE_H */
