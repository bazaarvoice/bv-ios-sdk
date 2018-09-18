//
//  BVFormFieldOptions.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//
//

#import "BVFormFieldOptions.h"
#import "BVNullHelper.h"

@implementation BVFormFieldOptions

- (id)initWithOptionsDictionary:(NSDictionary *)dictionary {
  if ((self = [super init])) {
    _label = @"";
    _value = @"";
    _selected = [NSNumber numberWithBool:NO];

    SET_IF_NOT_NULL(_label, [dictionary objectForKey:@"Label"])
    SET_IF_NOT_NULL(_value, [dictionary objectForKey:@"Value"])

    if ([dictionary objectForKey:@"Selected"]) {
      _selected = [NSNumber
          numberWithBool:[[dictionary objectForKey:@"Selected"] boolValue]];
    }
  }
  return self;
}

@end
