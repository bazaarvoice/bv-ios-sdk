//
//  BVProductSentimentsError.m
//  BVSDK
//
//  Copyright © 2025 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>

#import "BVProductSentimentsError.h"
#import "BVCommon.h"
#import "BVNullHelper.h"

NSString *__nonnull const BVKeyPSStatusCode = @"BVKeyPSStatusCode";
NSString *__nonnull const BVKeyPSErrorCode = @"BVKeyPSErrorCode";
NSString *__nonnull const BVKeyPSErrorMessage = @"BVKeyPSErrorMessage";

@implementation BVProductSentimentsError

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse statusCode:(nonnull NSString *)statusCode {
  if ((self = [super init])) {
    self.status = statusCode;
    self.code = @"N/A";
    self.message = @"N/A";

    SET_IF_NOT_NULL_WITH_ALTERNATE(self.code, apiResponse[@"code"], apiResponse[@"title"])
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.message, apiResponse[@"message"], apiResponse[@"detail"])
  }
  return self;
}

- (nonnull NSError *)toNSError {
  NSString *description =
      [NSString stringWithFormat:@"%@: %@\n%@", self.status, self.code, self.message];
  return [NSError errorWithDomain:BVErrDomain
                             code:BVKeyPSErrorDomainCode.integerValue
                         userInfo:@{
                           NSLocalizedDescriptionKey : description,
                           BVKeyPSStatusCode : self.status,
                           BVKeyPSErrorCode : self.message,
                           BVKeyPSErrorMessage : self.code
                         }];
}

@end
