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

@implementation BVConversationsError

- (nonnull id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    SET_IF_NOT_NULL(self.message, apiResponse[@"Message"])
    SET_IF_NOT_NULL(self.code, apiResponse[@"Code"])
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
