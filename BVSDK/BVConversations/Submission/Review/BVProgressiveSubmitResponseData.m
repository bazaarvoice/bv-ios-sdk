//
//  BVProgressiveSubmitResponseData.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVProgressiveSubmitResponseData.h"
#import "BVNullHelper.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVFormField.h"

@implementation BVProgressiveSubmitResponseData
- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse {
    if ((self = [super init])) {
        
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        NSDictionary *apiObject = (NSDictionary *)apiResponse;
        self.review = [[BVSubmittedReview alloc] initWithApiResponse:apiObject[@"review"]];
        SET_IF_NOT_NULL(self.submissionId, apiObject[@"submissionId"])
        SET_IF_NOT_NULL(self.submissionSessionToken, apiObject[@"submissionSessionToken"])
        SET_IF_NOT_NULL(self.fieldsOrder, apiResponse[@"fieldsOrder"])

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
