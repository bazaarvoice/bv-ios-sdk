//
//  BVPINRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVPIN.h"

@interface BVPINRequest : NSObject

+(void)getPendingPINs:(void(^ _Nonnull)(NSArray<BVPIN *> * _Nonnull pins))completion failure:(void(^ _Nonnull)(NSError * _Nonnull))failure;

@end
