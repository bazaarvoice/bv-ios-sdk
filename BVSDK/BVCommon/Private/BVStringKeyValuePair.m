//
//  BVStringKeyValuePair.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStringKeyValuePair.h"

@implementation BVStringKeyValuePair

+ (nonnull instancetype)pairWithKey:(nonnull NSString *)key
                              value:(nullable NSString *)value {
  BVStringKeyValuePair *pair = [[BVStringKeyValuePair alloc] init];
  pair.key = key;
  pair.value = value;
  return pair;
}

@end
