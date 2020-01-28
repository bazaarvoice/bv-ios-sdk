//
//  BVInitiateSubmitFormData.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVInitiateSubmitFormData.h"
#import "BVNullHelper.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVFormField.h"

@implementation BVInitiateSubmitFormData
- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        self.progressiveSubmissionReview = [[BVProgressiveSubmissionReview alloc] initWithApiResponse:apiResponse[@"review"] includes:nil];
        SET_IF_NOT_NULL(self.progressiveSubmissionReview.userNickname, apiResponse[@"userNickname"])
        SET_IF_NOT_NULL(self.fieldsOrder, apiResponse[@"fieldsOrder"])
        SET_IF_NOT_NULL(self.submissionSessionToken, apiResponse[@"submissionSessionToken"])
        
        NSMutableDictionary *tmpFields = [NSMutableDictionary dictionary];
        NSDictionary *fields = [apiResponse objectForKey:@"fields"];
        
        for (NSDictionary *fieldDict in [fields allValues]) {
            BVFormField *formField = [[BVFormField alloc] initWithFormFieldDictionary:fieldDict];
            [tmpFields setObject:formField forKey:formField.identifier];
        }
        self.formFields = tmpFields;
    }
    return self;
}
@end
