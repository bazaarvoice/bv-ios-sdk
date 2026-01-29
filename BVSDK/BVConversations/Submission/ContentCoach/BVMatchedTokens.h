//
//  BVMatchedTokens.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmittedType.h"

@interface BVMatchedTokens : BVSubmittedType

@property(nullable) NSNumber *status;
@property(nullable) NSString *type;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSArray<NSString *> *data;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
