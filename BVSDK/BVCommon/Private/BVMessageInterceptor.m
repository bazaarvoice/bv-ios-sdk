//
//  BVMessageInterceptor.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVMessageInterceptor.h"

@implementation BVMessageInterceptor

- (id)initWithMiddleman:(id)middleMan {
  if ((self = [super init])) {
    self.middleMan = middleMan;
  }
  return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
  if ([self.middleMan respondsToSelector:aSelector]) {
    return self.middleMan;
  }
  if ([self.receiver respondsToSelector:aSelector]) {
    return self.receiver;
  }
  return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  if ([@"_diffableDataSourceImpl" isEqualToString:NSStringFromSelector(aSelector)]) {
    return NO;
  }
  if ([self.middleMan respondsToSelector:aSelector]) {
    return YES;
  }
  if ([self.receiver respondsToSelector:aSelector]) {
    return YES;
  }
  return [super respondsToSelector:aSelector];
}

@end
