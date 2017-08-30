//
//  NSError+BVSubmissionErrorCodeParser.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "NSError+BVSubmissionErrorCodeParser.h"

@implementation NSError (BVErrorCodeParser)

-(BVSubmissionErrorCode)bvSubmissionErrorCode
{
    NSString* code = [self userInfo][BVFieldErrorCode];
    if (!code) {
        return BVSubmissionErrorCodeUnknown;
    }
    if([code isEqualToString:@"ERROR_FORM_DUPLICATE"]) {
        return BVSubmissionErrorCodeFormDuplicate;
    }
    if([code isEqualToString:@"ERROR_FORM_DUPLICATE_NICKNAME"]) {
        return BVSubmissionErrorCodeFormDuplicateNickname;
    }
    if([code isEqualToString:@"ERROR_FORM_INVALID_EMAILADDRESS"]) {
        return BVSubmissionErrorCodeFormInvalidEmailAddress;
    }
    if([code isEqualToString:@"ERROR_FORM_INVALID_IPADDRESS"]) {
        return BVSubmissionErrorCodeFormInvalidIpAddress;
    }
    if([code isEqualToString:@"ERROR_FORM_INVALID_OPTION"]) {
        return BVSubmissionErrorCodeFormInvalidOption;
    }
    if([code isEqualToString:@"ERROR_FORM_PATTERN_MISMATCH"]) {
        return BVSubmissionErrorCodeFormPatternMismatch;
    }
    if([code isEqualToString:@"ERROR_FORM_PROFANITY"]) {
        return BVSubmissionErrorCodeFormProfanity;
    }
    if([code isEqualToString:@"ERROR_FORM_REJECTED"]) {
        return BVSubmissionErrorCodeFormRejected;
    }
    if([code isEqualToString:@"ERROR_FORM_REQUIRED"]) {
        return BVSubmissionErrorCodeFormRequired;
    }
    if([code isEqualToString:@"ERROR_FORM_REQUIRED_EITHER"]) {
        return BVSubmissionErrorCodeFormRequiredEither;
    }
    if([code isEqualToString:@"ERROR_FORM_REQUIRED_NICKNAME"]) {
        return BVSubmissionErrorCodeFormRequiredNickname;
    }
    if([code isEqualToString:@"ERROR_FORM_REQUIRES_TRUE"]) {
        return BVSubmissionErrorCodeFormRequiresTrue;
    }
    if([code isEqualToString:@"ERROR_FORM_RESTRICTED"]) {
        return BVSubmissionErrorCodeFormRestricted;
    }
    if([code isEqualToString:@"ERROR_FORM_STORAGE_PROVIDER_FAILED"]) {
        return BVSubmissionErrorCodeFormStorageProviderFailed;
    }
    if([code isEqualToString:@"ERROR_FORM_SUBMITTED_NICKNAME"]) {
        return BVSubmissionErrorCodeFormSubmittedNickname;
    }
    if([code isEqualToString:@"ERROR_FORM_TOO_FEW"]) {
        return BVSubmissionErrorCodeFormTooFew;
    }
    if([code isEqualToString:@"ERROR_FORM_TOO_HIGH"]) {
        return BVSubmissionErrorCodeFormTooHigh;
    }
    if([code isEqualToString:@"ERROR_FORM_TOO_LONG"]) {
        return BVSubmissionErrorCodeFormTooLong;
    }
    if([code isEqualToString:@"ERROR_FORM_TOO_LOW"]) {
        return BVSubmissionErrorCodeFormTooLow;
    }
    if([code isEqualToString:@"ERROR_FORM_TOO_SHORT"]) {
        return BVSubmissionErrorCodeFormTooShort;
    }
    if([code isEqualToString:@"ERROR_FORM_UPLOAD_IO"]) {
        return BVSubmissionErrorCodeFormUploadIo;
    }
    if([code isEqualToString:@"ERROR_PARAM_DUPLICATE_SUBMISSION"]) {
        return BVSubmissionErrorCodeParamDuplicateSubmission;
    }
    if([code isEqualToString:@"ERROR_PARAM_INVALID_SUBJECT_ID"]) {
        return BVSubmissionErrorCodeParamInvalidSubjectId;
    }
    if([code isEqualToString:@"ERROR_PARAM_MISSING_SUBJECT_ID"]) {
        return BVSubmissionErrorCodeParamMissingSubjectId;
    }
    return BVSubmissionErrorCodeUnknown;
}

@end
