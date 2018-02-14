

//
//  BVCommentIncludeType.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentIncludeType.h"

@interface BVCommentIncludeType ()
@property(nonnull, nonatomic, readwrite) NSString *value;
@end

@implementation BVCommentIncludeType

+ (nonnull NSString *)toIncludeTypeParameterStringWithRawValue:
    (NSInteger)rawValue {
  return [BVCommentIncludeType includeTypeWithRawValue:rawValue].value;
}

+ (nonnull instancetype)includeTypeWithRawValue:(NSInteger)rawValue {
  return [[BVCommentIncludeType alloc] initWithRawValue:rawValue];
}

- (nonnull instancetype)initWithRawValue:(NSInteger)rawValue {
  if ((self = [super initWithRawValue:rawValue])) {
    switch (rawValue) {
    case BVCommentIncludeTypeValueCommentAuthors:
      self.value = @"Authors";
      break;
    case BVCommentIncludeTypeValueCommentProducts:
      self.value = @"Products";
      break;
    case BVCommentIncludeTypeValueCommentReviews:
      self.value = @"Reviews";
      break;
    }
  }
  return self;
}

- (nonnull NSString *)toIncludeTypeParameterString {
  return self.value;
}

- (nonnull instancetype)initWithCommentIncludeTypeValue:
    (BVCommentIncludeTypeValue)commentIncludeTypeValue {
  return [BVCommentIncludeType includeTypeWithRawValue:commentIncludeTypeValue];
}

@end
