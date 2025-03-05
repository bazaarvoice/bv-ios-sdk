//
//  BVProductSentimentsErrorResponse.m
//  BVSDK
//
//  Copyright © 2024 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "BVProductSentimentsErrorResponse.h"
#import "BVProductSentimentsError.h"
#import "BVNullHelper.h"
#import "BVProductSentimentsErrorCode.h"
#import "NSError+BVProductSentimentsErrorCodeParser.h"
//#import "BVConversationsError.h"

@interface BVProductSentimentsErrorResponse ()

@property(nonnull) NSArray<BVProductSentimentsError *> *errors;

@end

@implementation BVProductSentimentsErrorResponse

- (nullable id)initWithApiResponse:(nonnull NSDictionary *)apiResponse statusCode:(nonnull NSString *)statusCode {
  if ((self = [super init])) {
      NSMutableArray *errorsArrayBuilder = [NSMutableArray array];
      BVProductSentimentsError *error =
          [[BVProductSentimentsError alloc] initWithApiResponse:apiResponse statusCode:statusCode];
      [errorsArrayBuilder addObject:error];
      self.errors = errorsArrayBuilder;
  }
  return self;
}

- (nonnull NSArray<NSError *> *)toNSErrors {
    NSMutableArray *nsErrorsBuilder = [NSMutableArray array];

    for (BVProductSentimentsError *error in self.errors) {
      NSError *nsError = [error toNSError];
      [nsErrorsBuilder addObject:nsError];
    }

    return nsErrorsBuilder;
  }

@end
