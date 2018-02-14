//
//  BVPDPIncludeType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVIncludeType.h"
#import "BVPDPIncludeTypeValue.h"

@interface BVPDPIncludeType : BVIncludeType

- (nonnull instancetype)initWithPDPIncludeTypeValue:
    (BVPDPIncludeTypeValue)pdpIncludeTypeValue;

@end
