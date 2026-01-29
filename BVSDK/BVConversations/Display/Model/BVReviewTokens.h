//
//  BVReviewTokens.h
//  BVSDK
//
//  Copyright © 2026 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

@interface BVReviewTokens : NSObject

@property(nullable) NSNumber *status;
@property(nullable) NSString *type;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSArray<NSString *> *data;

- (nonnull id)initWithApiResponse:(nonnull id)apiResponse;

@end
