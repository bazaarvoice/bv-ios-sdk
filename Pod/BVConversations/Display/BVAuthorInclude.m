//
//  BVAuthorInclude.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorInclude.h"

@implementation BVAuthorInclude

- (nonnull id)initWithContentType:(BVAuthorContentType)type
                            limit:(nullable NSNumber *)limit {
  self = [super init];
  if (self) {
    self.type = type;
    self.limit = limit;
  }
  return self;
}

- (nonnull NSString *)toParamString {
  return [BVAuthorContentTypeUtil toString:self.type];
}

@end
