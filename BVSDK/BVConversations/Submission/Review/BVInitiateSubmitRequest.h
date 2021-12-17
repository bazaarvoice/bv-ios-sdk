//
//  BVInitiateSubmitRequest.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVConversations.h"
#import "BVSubmissionResponse.h"
#import "BVSubmission.h"
#import "BVInitiateSubmitResponseData.h"


NS_ASSUME_NONNULL_BEGIN

@interface BVInitiateSubmitRequest : BVSubmission <BVInitiateSubmitResponseData *>

/**
 Create a new BVInitiateSubmitRequest.
 
 @param productIds   The list of product IDs to be submitted.
 */

- (nonnull instancetype)initWithProductIds:(nonnull NSArray <NSString*> *)productIds;

@property(nonnull, readwrite) NSString *userId;
@property(nonnull, readwrite) NSString *userToken;
@property(nonnull, readwrite) NSString *locale;
@property(nullable) NSString *fingerPrint;
@property(nullable) NSString *campaignId;
@property BOOL extendedResponse;
@property BOOL hostedauth;

@end

NS_ASSUME_NONNULL_END
