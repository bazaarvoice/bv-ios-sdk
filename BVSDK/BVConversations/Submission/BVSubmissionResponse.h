//
//  SubmissionResponse.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Common information shared between submission response objects.
 */
@class BVSubmittedType;
@interface BVSubmissionResponse <__covariant ResultType : BVSubmittedType *> : NSObject

@property(nullable) NSString *locale;
@property(nullable) NSString *submissionId;
@property(nullable) NSNumber *typicalHoursToPost;
@property(nullable) NSString *authorSubmissionToken;

/// Form fields are present in Preview mode only. The form fileds are a
/// dictionry of BVFormField objects where the keys are form field elements. For
/// details, please also refer to the Bazaarvoice Developer Portal:
/// https://developer.bazaarvoice.com/docs/read/conversations_api/tutorials/submission/how_to_build_a_subission_form#fields-element
@property(nullable) NSDictionary *formFields;

@property(nullable) ResultType result;

- (nonnull instancetype)initWithApiResponse:(nonnull NSDictionary *)apiResponse;

@end
