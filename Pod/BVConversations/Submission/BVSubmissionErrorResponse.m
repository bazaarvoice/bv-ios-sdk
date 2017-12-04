//
//  SubmissionErrorResponse.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorResponse.h"
#import "BVNullHelper.h"

@implementation BVSubmissionErrorResponse

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
  self = [super init];
  if (self) {

    if (apiResponse == nil ||
        ![apiResponse isKindOfClass:[NSDictionary class]]) {
      return nil;
    }

    NSDictionary *apiObject = apiResponse;

    NSNumber *hasErrs = apiObject[@"HasErrors"];
    if (hasErrs != nil) {
      self.hasErrors = [hasErrs boolValue];
    }

    if (self.hasErrors == false) {
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
