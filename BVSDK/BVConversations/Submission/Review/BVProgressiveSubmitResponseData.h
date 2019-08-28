//
//  BVProgressiveSubmitResponseData.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVSubmittedType.h"
#import "BVSubmittedReview.h"
#import "BVReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVProgressiveSubmitResponseData : BVSubmittedType
@property(nullable) NSString *submissionSessionToken;
@property(nullable) BVSubmittedReview *review;
@property(nullable) NSString *submissionId;
@property(nullable) NSArray<NSString *> *fieldsOrder;
@property(nullable) NSDictionary *formFields;
@property(nullable) NSNumber *isFormComplete;

@end

NS_ASSUME_NONNULL_END
