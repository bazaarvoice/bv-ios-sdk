//
//  BVMultiProductSubmission.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVConversations.h"
#import "BVSubmissionResponse.h"
#import "BVSubmission.h"
#import "BVSubmittedMultiProduct.h"


NS_ASSUME_NONNULL_BEGIN

@interface BVMultiProductSubmission : BVSubmission <BVSubmittedMultiProduct *>

/**
 Create a new BVMultiProductSubmission.
 
 @param userToken    The authentication token of the user that the submission request is associated
 with.
 @param productIds   The list of product IDs to be submitted.
 */
- (nonnull instancetype)initWithUserToken:(nonnull NSString *)userToken
                               productIds:(nonnull NSArray <NSString *>*)productIds;

@end

NS_ASSUME_NONNULL_END
