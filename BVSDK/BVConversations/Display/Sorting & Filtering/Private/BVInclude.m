//
//  BVIncludeType.m
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import "BVInclude.h"

@interface BVInclude ()
@property(nonnull, strong) NSString *includeType;
@property(nullable, strong, readwrite) NSNumber *includeLimit;
@end

@implementation BVInclude

- (nonnull id)initWithIncludeType:
    (nonnull id<BVIncludeTypeProtocol>)includeType {
  return [self initWithIncludeType:includeType includeLimit:nil];
}

- (nonnull id)initWithIncludeType:(nonnull id<BVIncludeTypeProtocol>)includeType
                     includeLimit:(nullable NSNumber *)includeLimit {
  if ((self = [super init])) {
    self.includeType = [includeType toIncludeTypeParameterString];
    self.includeLimit = includeLimit;
  }
  return self;
}

- (nonnull NSString *)toParameterString {
  return self.includeType;
}

@end
