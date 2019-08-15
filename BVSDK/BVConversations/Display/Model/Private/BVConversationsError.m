//
//  ConversationsError.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsError.h"
#import "BVCommon.h"
#import "BVNullHelper.h"

NSString *__nonnull const BVKeyErrorCode = @"BVKeyErrorCode";
NSString *__nonnull const BVKeyErrorMessage = @"BVKeyErrorMessage";
NSString *__nonnull const BVKeyErrorField = @"BVKeyErrorField";

@implementation BVConversationsError

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    self.code = @"N/A";
    self.message = @"N/A";
    self.field = @"N/A";
      
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.code, apiResponse[@"Code"], apiResponse[@"code"])
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.message, apiResponse[@"Message"], apiResponse[@"message"])
    SET_IF_NOT_NULL_WITH_ALTERNATE(self.field, apiResponse[@"Field"], apiResponse[@"field"])
  }
  return self;
}

- (nonnull NSError *)toNSError {
  NSString *description =
      [NSString stringWithFormat:@"%@: %@", self.code, self.message];
  return [NSError errorWithDomain:BVErrDomain
                             code:BVKeyErrorDomainCode.integerValue
                         userInfo:@{
                           NSLocalizedDescriptionKey : description,
                           BVKeyErrorMessage : self.message,
                           BVKeyErrorField : self.field,
                           BVKeyErrorCode : self.code
                         }];
}

+ (nonnull NSArray<BVConversationsError *> *)createErrorListFromApiResponse:
    (nullable id)apiResponse {
  NSMutableArray<BVConversationsError *> *errors = [NSMutableArray array];

  if ([apiResponse isKindOfClass:[NSArray<NSDictionary *> class]]) {
    NSArray<NSDictionary *> *apiObject = (NSArray<NSDictionary *> *)apiResponse;

    for (NSDictionary *errorDict in apiObject) {
      BVConversationsError *error =
          [[BVConversationsError alloc] initWithApiResponse:errorDict];
      [errors addObject:error];
    }
  }
  return errors;
}

@end
