//
//  BVSubmittedMultiProduct.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
//

#import "BVSubmittedType.h"
#import "BVMultiProductInfo.h"
#import "BVProduct.h"

@interface BVSubmittedMultiProduct : BVSubmittedType

@property(nonnull) NSArray<BVMultiProductInfo *> *products;
@property(nonnull) NSString *interactionId;
@property(nullable) NSString *userNickname;

@end
