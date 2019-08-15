//
//  BVInitiateSubmitResponseData.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"
#import "BVInitiateSubmitFormData.h"
#import "BVProduct.h"

@interface BVInitiateSubmitResponseData : BVSubmittedType

@property(nonnull) NSDictionary *products;

@end
