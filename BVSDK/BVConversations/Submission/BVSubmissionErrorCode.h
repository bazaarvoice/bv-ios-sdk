//
//  BVSubmissionErrorCode.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Type of form error code
 */
typedef NS_ENUM(NSInteger, BVSubmissionErrorCode) {
  BVSubmissionErrorCodeFormDuplicate,
  BVSubmissionErrorCodeFormDuplicateNickname,
  BVSubmissionErrorCodeFormInvalidEmailAddress,
  BVSubmissionErrorCodeFormInvalidIpAddress,
  BVSubmissionErrorCodeFormInvalidOption,
  BVSubmissionErrorCodeFormPatternMismatch,
  BVSubmissionErrorCodeFormProfanity,
  BVSubmissionErrorCodeFormRejected,
  BVSubmissionErrorCodeFormRequired,
  BVSubmissionErrorCodeFormRequiredEither,
  BVSubmissionErrorCodeFormRequiredNickname,
  BVSubmissionErrorCodeFormRequiresTrue,
  BVSubmissionErrorCodeFormRestricted,
  BVSubmissionErrorCodeFormStorageProviderFailed,
  BVSubmissionErrorCodeFormSubmittedNickname,
  BVSubmissionErrorCodeFormTooFew,
  BVSubmissionErrorCodeFormTooHigh,
  BVSubmissionErrorCodeFormTooLong,
  BVSubmissionErrorCodeFormTooLow,
  BVSubmissionErrorCodeFormTooShort,
  BVSubmissionErrorCodeFormUploadIo,
  BVSubmissionErrorCodeParamDuplicateSubmission,
  BVSubmissionErrorCodeParamInvalidSubjectId,
  BVSubmissionErrorCodeParamMissingSubjectId,
  BVSubmissionErrorCodeFormFutureDate,
  BVSubmissionErrorCodeUnknown
};
