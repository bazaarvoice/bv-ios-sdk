//
//  BVFormField.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVFormFieldOptions.h"
#import "BVFormInputType.h"

/**
  This model is a single element of a Conversations Submission Form.
  The fields elements are defined in the Conversations API Submission documentation: https://developer.bazaarvoice.com/docs/read/conversations_api/tutorials/submission/how_to_build_a_subission_form#fields-element
 
   The BVFormFields can be obtained for a Review/Question/Answer submission by running a Submission request in .Preview mode.
 */
@interface BVFormField : NSObject

@property NSArray<BVFormFieldOptions *> * _Nonnull options;
@property BVFormInputType bvFormInputType;

@property NSString * _Nonnull identifier;
@property NSString * _Nonnull label;
@property NSString * _Nonnull type;
@property NSString * _Nonnull value;
@property NSNumber * _Nonnull required; // Boolean
@property NSNumber * _Nonnull minLength; // Integer
@property NSNumber * _Nonnull maxLength; // Integer
@property NSNumber * _Nonnull isDefault; // Boolean

- (id _Nonnull)initWithFormFieldDictionary:(NSDictionary * _Nonnull)fieldDictionary;

@end
