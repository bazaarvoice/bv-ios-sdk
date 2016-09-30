//
//  BVFormField.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "BVFormFieldOptions.h"

@interface BVFormField : NSObject

@property NSArray<BVFormFieldOptions *> * _Nonnull options;

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
