//
//  BVSubmittedUAS.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"

/// A successfully submitted user authenticated string.
@interface BVSubmittedUAS : BVSubmittedType

@property(nullable, readonly) NSString *authenticatedUser;
@end
