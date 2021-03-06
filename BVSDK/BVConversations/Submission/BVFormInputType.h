//
//  BVFormInputType.h
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Type of form input type.
 */
typedef NS_ENUM(NSInteger, BVFormInputType) {
  BVFormInputTypeBooleanInput,
  BVFormInputTypeFileInput,
  BVFormInputTypeIntegerInput,
  BVFormInputTypeSelectInput,
  BVFormInputTypeTextAreaInput,
  BVFormInputTypeTextInput,
  BVFormInputTypeUnknown
};

@interface BVFormInputTypeUtil : NSObject

+ (BVFormInputType)fromString:(nullable NSString *)str;

@end
