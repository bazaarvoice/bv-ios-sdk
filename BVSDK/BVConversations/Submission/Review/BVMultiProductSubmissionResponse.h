//
//  BVMultiProductSubmissionResponse.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 
#import "BVSubmissionResponse.h"
#import "BVSubmittedMultiProduct.h"
#import <Foundation/Foundation.h>

@interface BVMultiProductSubmissionResponse : BVSubmissionResponse <BVSubmittedMultiProduct *>

@end
