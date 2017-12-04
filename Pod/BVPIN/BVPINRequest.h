//
//  BVPINRequest.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVPIN.h"
#import <Foundation/Foundation.h>

@interface BVPINRequest : NSObject

+ (void)getPendingPINs:
            (nonnull void (^)(NSArray<BVPIN *> *__nonnull pins))completion
               failure:(nonnull void (^)(NSError *__nonnull))failure;

@end
