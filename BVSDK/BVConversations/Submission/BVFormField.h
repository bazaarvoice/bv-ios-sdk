//
//  BVFormField.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVFormFieldOptions.h"
#import "BVFormInputType.h"
#import <Foundation/Foundation.h>

/**
  This model is a single element of a Conversations Submission Form.
  The fields elements are defined in the Conversations API Submission
  documentation:
  https://developer.bazaarvoice.com/docs/read/conversations_api/tutorials/submission/how_to_build_a_subission_form#fields-element

   The BVFormFields can be obtained for a Review/Question/Answer submission by
  running a Submission request in .Preview mode.
 */
@interface BVFormField : NSObject

@property(nonnull) NSArray<BVFormFieldOptions *> *options;
@property BVFormInputType bvFormInputType;

@property(nonnull) NSString *identifier;
@property(nonnull) NSString *label;
@property(nonnull) NSString *type;
@property(nonnull) NSString *value;
@property(nonnull) NSNumber *required;  // Boolean
@property(nonnull) NSNumber *minLength; // Integer
@property(nonnull) NSNumber *maxLength; // Integer
@property(nonnull) NSNumber *isDefault; // Boolean

- (nonnull id)initWithFormFieldDictionary:
    (nonnull NSDictionary *)fieldDictionary;

@end
