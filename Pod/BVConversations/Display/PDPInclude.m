//
//  Include.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "PDPInclude.h"

@implementation PDPInclude

- (nonnull id)initWithContentType:(PDPContentType)type
                            limit:(nullable NSNumber *)limit {
  self = [super init];
  if (self) {
    self.type = type;
    self.limit = limit;
  }
  return self;
}

- (nonnull NSString *)toParamString {
  return [PDPContentTypeUtil toString:self.type];
}

@end
