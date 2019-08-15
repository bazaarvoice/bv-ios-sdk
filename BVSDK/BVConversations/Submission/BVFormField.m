//
//  BVFormField.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVFormField.h"
#import "BVFormFieldOptions.h"
#import "BVNullHelper.h"

@implementation BVFormField

- (id)initWithFormFieldDictionary:(NSDictionary *)fieldDictionary {
  if ((self = [super init])) {
    _identifier = @"";
    _label = @"";
    _type = @"";
    _value = @"";
      _classification = @"";
    _required = [NSNumber numberWithBool:NO];
    _isDefault = [NSNumber numberWithBool:NO];
    _minLength = [NSNumber numberWithInteger:0];
    _maxLength = [NSNumber numberWithInteger:0];

    SET_IF_NOT_NULL_WITH_ALTERNATE(_identifier, [fieldDictionary objectForKey:@"Id"], [fieldDictionary objectForKey:@"id"]);
    SET_IF_NOT_NULL_WITH_ALTERNATE(_label, [fieldDictionary objectForKey:@"Label"], [fieldDictionary objectForKey:@"label"]);
    SET_IF_NOT_NULL_WITH_ALTERNATE(_type, [fieldDictionary objectForKey:@"Type"], [fieldDictionary objectForKey:@"type"]);
    SET_IF_NOT_NULL_WITH_ALTERNATE(_value, [fieldDictionary objectForKey:@"Value"], [fieldDictionary objectForKey:@"value"]);
    SET_IF_NOT_NULL_WITH_ALTERNATE(_classification, [fieldDictionary objectForKey:@"Class"], [fieldDictionary objectForKey:@"class"]);
    SET_IF_NOT_NULL_WITH_ALTERNATE(_valuesLabels, [fieldDictionary objectForKey:@"ValuesLabels"], [fieldDictionary objectForKey:@"valuesLabels"]);
      
    _bvFormInputType = [BVFormInputTypeUtil fromString:_type];

    if (!isObjectNilOrNull([fieldDictionary objectForKey:@"MinLength"])) {
      _minLength = [NSNumber
          numberWithInteger:[[fieldDictionary objectForKey:@"MinLength"]
                                integerValue]];
    } else if (!isObjectNilOrNull([fieldDictionary objectForKey:@"minLength"])) {
        _minLength = [NSNumber
                      numberWithInteger:[[fieldDictionary objectForKey:@"minLength"]
                                         integerValue]];
    }

    if (!isObjectNilOrNull([fieldDictionary objectForKey:@"MaxLength"])) {
      _maxLength = [NSNumber
          numberWithInteger:[[fieldDictionary objectForKey:@"MaxLength"]
                                integerValue]];
    } else if (!isObjectNilOrNull([fieldDictionary objectForKey:@"maxLength"])) {
        _maxLength = [NSNumber
                      numberWithInteger:[[fieldDictionary objectForKey:@"maxLength"]
                                         integerValue]];
    }

    if (!isObjectNilOrNull([fieldDictionary objectForKey:@"Required"])) {
      _required =
          [NSNumber numberWithInteger:[[fieldDictionary
                                          objectForKey:@"Required"] boolValue]];
    } else if (!isObjectNilOrNull([fieldDictionary objectForKey:@"required"])) {
        _required =
        [NSNumber numberWithInteger:[[fieldDictionary
                                      objectForKey:@"required"] boolValue]];
    }

    if (!isObjectNilOrNull([fieldDictionary objectForKey:@"Default"])) {
      _isDefault =
          [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"Default"]
                                          boolValue]];
    } else if (!isObjectNilOrNull([fieldDictionary objectForKey:@"default"])) {
        _isDefault =
        [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"default"]
                                     boolValue]];
    }
     
    if (!isObjectNilOrNull([fieldDictionary objectForKey:@"AutoPopulate"])) {
        _isDefault =
        [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"AutoPopulate"]
                                       boolValue]];
    } else if (!isObjectNilOrNull([fieldDictionary objectForKey:@"autoPopulate"])) {
        _isDefault =
        [NSNumber numberWithInteger:[[fieldDictionary objectForKey:@"autoPopulate"]
                                       boolValue]];
    }

    NSMutableArray *tmpOptions = [NSMutableArray array];
    for (NSDictionary *optionsDict in
         [fieldDictionary objectForKey:@"Options"]) {
      BVFormFieldOptions *fieldOptions =
          [[BVFormFieldOptions alloc] initWithOptionsDictionary:optionsDict];
      [tmpOptions addObject:fieldOptions];
    }

    _options = [NSArray arrayWithArray:tmpOptions];
  }
  return self;
}

@end
