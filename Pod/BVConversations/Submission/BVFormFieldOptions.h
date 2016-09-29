//
//  BVFormFieldOptions.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>

/**
  The BVFormFieldOptions are values that have been configured for a parent BVFormField element. An example when to use the Options array, is in forms that contain a UIPicker control. Programmatically a developer would iterate over the array extracting out the values and label to construct a UIPikcer.
 
 For more information, please see the Options section of Bazaarvioce Submission Form documentation: https://developer.bazaarvoice.com/docs/read/conversations_api/tutorials/submission/how_to_build_a_subission_form#fields-element
 
 */
@interface BVFormFieldOptions : NSObject

@property NSString* _Nonnull label;
@property NSString* _Nonnull value;
@property NSNumber* _Nonnull selected; // Boolean

- (id _Nonnull)initWithOptionsDictionary:(NSDictionary * _Nonnull)dictionary;

@end
