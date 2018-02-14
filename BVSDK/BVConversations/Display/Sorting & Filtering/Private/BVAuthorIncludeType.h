//
//  BVAuthorIncludeType.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVAuthorIncludeTypeValue.h"
#import "BVIncludeType.h"

@interface BVAuthorIncludeType : BVIncludeType

- (nonnull instancetype)initWithAuthorIncludeTypeValue:
    (BVAuthorIncludeTypeValue)authorIncludeTypeValue;

@end
