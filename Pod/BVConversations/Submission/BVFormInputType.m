//
//  BVFormInputType.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVFormInputType.h"

@implementation BVFormInputTypeUtil

+ (BVFormInputType)fromString:(nullable NSString *)str {
  if ([str isEqualToString:@"BooleanInput"]) {
    return BVFormInputTypeBooleanInput;
  }
  if ([str isEqualToString:@"FileInput"]) {
    return BVFormInputTypeFileInput;
  }
  if ([str isEqualToString:@"IntegerInput"]) {
    return BVFormInputTypeIntegerInput;
  }
  if ([str isEqualToString:@"SelectInput"]) {
    return BVFormInputTypeSelectInput;
  }
  if ([str isEqualToString:@"TextAreaInput"]) {
    return BVFormInputTypeTextAreaInput;
  }
  if ([str isEqualToString:@"TextInput"]) {
    return BVFormInputTypeTextInput;
  }
  return BVFormInputTypeUnknown;
}

@end
