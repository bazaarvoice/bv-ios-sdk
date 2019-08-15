//
//  BVProgressiveSubmissionReview.m
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import "BVProgressiveSubmissionReview.h"
#import "BVNullHelper.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVProgressiveSubmissionReview

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
    if ((self = [super initWithApiResponse:apiResponse includes:nil])) {
        if (!__IS_KIND_OF(apiResponse, NSDictionary)) {
            return nil;
        }
        SET_IF_NOT_NULL(self.isFromSubmitDB, apiResponse[@"isFromSubmitDB"])
        SET_IF_NOT_NULL(self.previousSubmissionID, apiResponse[@"previousSubmissionID"])
        SET_IF_NOT_NULL(self.photoCollection, apiResponse[@"photos"])
    }
    return self;
}
@end
