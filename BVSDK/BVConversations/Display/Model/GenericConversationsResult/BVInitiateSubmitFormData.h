//
//  BVInitiateSubmitFormData.h
//  BVSDK
//
//  Copyright © 2019 Bazaarvoice. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import "BVProgressiveSubmissionReview.h"

NS_ASSUME_NONNULL_BEGIN

@interface BVInitiateSubmitFormData : NSObject
@property(nullable) BVProgressiveSubmissionReview *progressiveSubmissionReview;
@property(nullable) NSArray<NSString *> *fieldsOrder;
@property(nullable) NSDictionary *formFields;
@property(nullable) NSString *submissionSessionToken;

- (nullable instancetype)initWithApiResponse:(nullable id)apiResponse;

@end

NS_ASSUME_NONNULL_END
