//
//  BVProgressiveSubmitRequest.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmission.h"
#import "BVConversations.h"
#import "BVSubmissionResponse.h"
#import "BVProgressiveSubmitResponseData.h"

NS_ASSUME_NONNULL_BEGIN 

@interface BVProgressiveSubmitRequest : BVSubmission <BVProgressiveSubmitResponseData *>

- (nonnull instancetype)initWithProductId:(nonnull NSString *)productId;
@property(nonnull, readwrite) NSString *productId;
@property(nullable, readwrite) NSString *userToken;
@property(nullable, readwrite) NSString *userId;
@property(nullable, readwrite) NSString *userEmail;
@property(nonnull, readwrite)  NSDictionary *submissionFields;
@property(nullable, readwrite) NSString *submissionSessionToken;
@property(nullable) NSString *locale;
@property BOOL first;
@property(nullable) NSString *fingerPrint;
@property(nullable) NSString *campaignId;
@property BOOL extendedResponse;
@property BOOL includeFields;
@property BOOL isPreview;

@end

NS_ASSUME_NONNULL_END
