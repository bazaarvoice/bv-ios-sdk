//
//  BVErrorCode.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Type of error code
 */
typedef NS_ENUM(NSInteger, BVErrorCode) {
  // Common
  BVErrorCodeBadRequest,
  BVErrorCodeUnknown,
  BVErrorCodeAccessDenied,
  BVErrorCodeParamInvalidApiKey,
  BVErrorCodeParamInvalidLocale,
  BVErrorCodeRequestLimitReached,
  BVErrorCodeUnsupported,

  // Display Request Specific
  BVErrorCodeParamInvalidCallback,
  BVErrorCodeParamInvalidFilterAttribute,
  BVErrorCodeParamInvalidIncluded,
  BVErrorCodeParamInvalidLimit,
  BVErrorCodeParamInvalidOffset,
  BVErrorCodeParamInvalidSearchAttribute,
  BVErrorCodeParamInvalidSortAttribute,
  BVErrorCodeParamInvalidFeatureAttribute,

  // Submission Request Specific
  BVErrorCodeDuplicateSubmission,
  BVErrorCodeParamInvalidParameters,
  BVErrorCodeParamMissingUserId
};
