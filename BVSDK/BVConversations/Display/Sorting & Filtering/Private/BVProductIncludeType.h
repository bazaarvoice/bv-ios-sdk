//
//  BVProductIncludeType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVIncludeType.h"
#import "BVProductIncludeTypeValue.h"

@interface BVProductIncludeType : BVIncludeType

- (nonnull instancetype)initWithPDPIncludeTypeValue:
    (BVProductIncludeTypeValue)pdpIncludeTypeValue;

@end
