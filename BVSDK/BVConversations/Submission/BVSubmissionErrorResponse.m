//
//  SubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVConversationsError.h"
#import "BVFieldError.h"
#import "BVNullHelper.h"
#import "BVSubmissionErrorResponse+Private.h"

@interface BVSubmissionErrorResponse ()
@property(nonnull) NSArray<BVConversationsError *> *errors;
@end

@implementation BVSubmissionErrorResponse

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {

    if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
      return nil;
    }

    NSDictionary *apiObject = (NSDictionary *)apiResponse;

    NSNumber *hasErrs = apiObject[@"HasErrors"];
    self.hasErrors = (hasErrs && [hasErrs boolValue]) ? YES : NO;

    if (!self.hasErrors) {
      return nil;
    }

    SET_IF_NOT_NULL(self.locale, apiObject[@"Locale"])
    SET_IF_NOT_NULL(self.submissionId, apiObject[@"SubmissionId"])
    SET_IF_NOT_NULL(self.typicalHoursToPost, apiObject[@"TypicalHoursToPost"])
    SET_IF_NOT_NULL(self.authorSubmissionToken,
                    apiObject[@"AuthorSubmissionToken"])

    self.errors = [BVConversationsError
        createErrorListFromApiResponse:apiObject[@"Errors"]];
    self.fieldErrors = [BVFieldError
        createListFromFormErrorsDictionary:apiObject[@"FormErrors"]];
  }
  return self;
}

- (nonnull NSArray<NSError *> *)toNSErrors {

  NSMutableArray<NSError *> *tempErrors = [NSMutableArray array];
  for (BVConversationsError *error in self.errors) {
    [tempErrors addObject:[error toNSError]];
  }

  for (BVFieldError *error in self.fieldErrors) {
    [tempErrors addObject:[error toNSError]];
  }

  return tempErrors;
}

@end
