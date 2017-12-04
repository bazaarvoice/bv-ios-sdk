//
//  NSError+BVErrorCodeParser.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVConversationsError.h"
#import "NSError+BVErrorCodeParser.h"

@implementation NSError (BVErrorCodeParser)

- (BVErrorCode)bvErrorCode {
  NSString *code = [self userInfo][BVKeyErrorCode];
  if (!code) {
    return BVErrorCodeUnknown;
  }
  if ([code isEqualToString:@"ERROR_BAD_REQUEST"]) {
    return BVErrorCodeBadRequest;
  }
  if ([code isEqualToString:@"ERROR_ACCESS_DENIED"]) {
    return BVErrorCodeAccessDenied;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_API_KEY"]) {
    return BVErrorCodeParamInvalidApiKey;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_LOCALE"]) {
    return BVErrorCodeParamInvalidLocale;
  }
  if ([code isEqualToString:@"ERROR_REQUEST_LIMIT_REACHED"]) {
    return BVErrorCodeRequestLimitReached;
  }
  if ([code isEqualToString:@"ERROR_UNSUPPORTED"]) {
    return BVErrorCodeUnsupported;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_CALLBACK"]) {
    return BVErrorCodeParamInvalidCallback;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_FILTER_ATTRIBUTE"]) {
    return BVErrorCodeParamInvalidFilterAttribute;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_INCLUDED"]) {
    return BVErrorCodeParamInvalidIncluded;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_LIMIT"]) {
    return BVErrorCodeParamInvalidLimit;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_OFFSET"]) {
    return BVErrorCodeParamInvalidOffset;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_SEARCH_ATTRIBUTE"]) {
    return BVErrorCodeParamInvalidSearchAttribute;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_SORT_ATTRIBUTE"]) {
    return BVErrorCodeParamInvalidSortAttribute;
  }
  if ([code isEqualToString:@"ERROR_DUPLICATE_SUBMISSION"]) {
    return BVErrorCodeDuplicateSubmission;
  }
  if ([code isEqualToString:@"ERROR_PARAM_INVALID_PARAMETERS"]) {
    return BVErrorCodeParamInvalidParameters;
  }
  if ([code isEqualToString:@"ERROR_PARAM_MISSING_USER_ID"]) {
    return BVErrorCodeParamMissingUserId;
  }
  return BVErrorCodeUnknown;
}

@end
