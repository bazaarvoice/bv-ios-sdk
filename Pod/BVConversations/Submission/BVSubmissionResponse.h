//
//  SubmissionResponse.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Common information shared between submission response objects.
 */
@interface BVSubmissionResponse : NSObject

@property NSString* _Nullable locale;
@property NSString* _Nullable submissionId;
@property NSNumber* _Nullable typicalHoursToPost;
@property NSString* _Nullable authorSubmissionToken;

/// Form fields are present in Preview mode only. The form fileds are a dictionry of BVFormField objects where the keys are form field elements. For details, please also refer to the Bazaarvoice Developer Portal: https://developer.bazaarvoice.com/docs/read/conversations_api/tutorials/submission/how_to_build_a_subission_form#fields-element
@property NSDictionary * _Nullable formFields;

-(nonnull instancetype)initWithApiResponse:(nonnull NSDictionary*)apiResponse;

@end
