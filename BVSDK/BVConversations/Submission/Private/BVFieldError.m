//
//  BVFieldError.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFieldError.h"
#import "BVCommon.h"
#import "BVNullHelper.h"
#import "BVSubmissionErrorCode.h"

NSString *__nonnull const BVFieldErrorName = @"BVFieldErrorName";
NSString *__nonnull const BVFieldErrorMessage = @"BVFieldErrorMessage";
NSString *__nonnull const BVFieldErrorCode = @"BVFieldErrorCode";

@implementation BVFieldError

- (nullable instancetype)initWithApiResponse:
    (nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.fieldName, apiResponse[@"Field"], apiResponse[@"field"])
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.message, apiResponse[@"Message"], apiResponse[@"message"])
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.code, apiResponse[@"Code"], apiResponse[@"code"])
  }
  return self;
}

- (nonnull NSError *)toNSError {
  return [NSError errorWithDomain:BVErrDomain
                             code:BV_ERROR_FIELD_INVALID
                         userInfo:@{
                           NSLocalizedDescriptionKey : [NSString
                               stringWithFormat:@"%@: %@: %@", self.fieldName,
                                                self.code, self.message],
                           BVFieldErrorName : self.fieldName,
                           BVFieldErrorMessage : self.message,
                           BVFieldErrorCode : self.code
                         }];
}

+ (nonnull NSArray<BVFieldError *> *)createListFromFormErrorsDictionary:
    (nullable id)apiResponse {
  if (!apiResponse || ![apiResponse isKindOfClass:[NSDictionary class]]) {
    return @[];
  }

  NSDictionary *apiObject = apiResponse;

  NSMutableArray<BVFieldError *> *results = [NSMutableArray array];
  NSDictionary *rawFieldErrors = apiObject[@"FieldErrors"];

  for (NSString *key in rawFieldErrors) {
    NSDictionary *rawFieldError = rawFieldErrors[key];

    BVFieldError *fieldError =
        [[BVFieldError alloc] initWithApiResponse:rawFieldError];
    if (fieldError) {
      [results addObject:fieldError];
    }
  }

  return results;
}

@end
