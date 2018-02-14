//
//  BVStoreIncludeType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVIncludeType.h"
#import "BVStoreIncludeTypeValue.h"

@interface BVStoreIncludeType : BVIncludeType

- (nonnull instancetype)initWithStoreIncludeTypeValue:
    (BVStoreIncludeTypeValue)storeIncludeTypeValue;

@end
