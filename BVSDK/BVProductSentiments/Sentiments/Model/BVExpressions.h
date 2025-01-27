//
//  BVExpressions.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import "BVProductSentimentsResult.h"

@interface BVExpressions : BVProductSentimentsResult

@property(nullable) NSString *nativeFeature;
@property(nullable) NSArray<NSString *> *expressions;
@property(nullable) NSNumber *status;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *type;
@property(nullable) NSString *instance;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end
