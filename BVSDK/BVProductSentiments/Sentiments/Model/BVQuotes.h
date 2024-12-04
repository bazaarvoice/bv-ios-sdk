//
//  BVQuotes.h
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVQuote.h"

@interface BVQuotes : NSObject

@property(nullable) NSArray<BVQuote *> *quotes;
@property(nullable) NSNumber *status;
@property(nullable) NSString *title;
@property(nullable) NSString *detail;
@property(nullable) NSString *type;
@property(nullable) NSString *instance;

- (nullable id)initWithApiResponse:(nullable id)apiResponse;

@end

