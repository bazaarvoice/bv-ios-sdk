//
//  BVSubmissionErrorCode.m
//  Pods
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVSubmissionErrorCode.h"

@implementation BVSubmissionErrorCodeUtil

+ (BVSubmissionErrorCode)fromString:(NSString* _Nullable)str{
    if([str isEqualToString:@"ERROR_FORM_DUPLICATE"]) {
        return BVSubmissionErrorCodeFormDuplicate;
    }
    if([str isEqualToString:@"ERROR_FORM_DUPLICATE_NICKNAME"]) {
        return BVSubmissionErrorCodeFormDuplicateNickname;
    }
    if([str isEqualToString:@"ERROR_FORM_INVALID_EMAILADDRESS"]) {
        return BVSubmissionErrorCodeFormInvalidEmailAddress;
    }
    if([str isEqualToString:@"ERROR_FORM_INVALID_IPADDRESS"]) {
        return BVSubmissionErrorCodeFormInvalidIpAddress;
    }
    if([str isEqualToString:@"ERROR_FORM_INVALID_OPTION"]) {
        return BVSubmissionErrorCodeFormInvalidOption;
    }
    if([str isEqualToString:@"ERROR_FORM_PATTERN_MISMATCH"]) {
        return BVSubmissionErrorCodeFormPatternMismatch;
    }
    if([str isEqualToString:@"ERROR_FORM_PROFANITY"]) {
        return BVSubmissionErrorCodeFormProfanity;
    }
    if([str isEqualToString:@"ERROR_FORM_REJECTED"]) {
        return BVSubmissionErrorCodeFormRejected;
    }
    if([str isEqualToString:@"ERROR_FORM_REQUIRED"]) {
        return BVSubmissionErrorCodeFormRequired;
    }
    if([str isEqualToString:@"ERROR_FORM_REQUIRED_EITHER"]) {
        return BVSubmissionErrorCodeFormRequiredEither;
    }
    if([str isEqualToString:@"ERROR_FORM_REQUIRED_NICKNAME"]) {
        return BVSubmissionErrorCodeFormRequiredNickname;
    }
    if([str isEqualToString:@"ERROR_FORM_REQUIRES_TRUE"]) {
        return BVSubmissionErrorCodeFormRequiresTrue;
    }
    if([str isEqualToString:@"ERROR_FORM_RESTRICTED"]) {
        return BVSubmissionErrorCodeFormRestricted;
    }
    if([str isEqualToString:@"ERROR_FORM_STORAGE_PROVIDER_FAILED"]) {
        return BVSubmissionErrorCodeFormStorageProviderFailed;
    }
    if([str isEqualToString:@"ERROR_FORM_SUBMITTED_NICKNAME"]) {
        return BVSubmissionErrorCodeFormSubmittedNickname;
    }
    if([str isEqualToString:@"ERROR_FORM_TOO_FEW"]) {
        return BVSubmissionErrorCodeFormTooFew;
    }
    if([str isEqualToString:@"ERROR_FORM_TOO_HIGH"]) {
        return BVSubmissionErrorCodeFormTooHigh;
    }
    if([str isEqualToString:@"ERROR_FORM_TOO_LONG"]) {
        return BVSubmissionErrorCodeFormTooLong;
    }
    if([str isEqualToString:@"ERROR_FORM_TOO_LOW"]) {
        return BVSubmissionErrorCodeFormTooLow;
    }
    if([str isEqualToString:@"ERROR_FORM_TOO_SHORT"]) {
        return BVSubmissionErrorCodeFormTooShort;
    }
    if([str isEqualToString:@"ERROR_FORM_UPLOAD_IO"]) {
        return BVSubmissionErrorCodeFormUploadIo;
    }
    if([str isEqualToString:@"ERROR_PARAM_DUPLICATE_SUBMISSION"]) {
        return BVSubmissionErrorCodeParamDuplicateSubmission;
    }
    if([str isEqualToString:@"ERROR_PARAM_INVALID_SUBJECT_ID"]) {
        return BVSubmissionErrorCodeParamInvalidSubjectId;
    }
    if([str isEqualToString:@"ERROR_PARAM_MISSING_SUBJECT_ID"]) {
        return BVSubmissionErrorCodeParamMissingSubjectId;
    }
    return BVSubmissionErrorCodeUnknown;
}

@end
