//
//  CommaUtil.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVCommaUtil.h"

@implementation BVCommaUtil

+ (nonnull NSString *)escape:(nonnull NSString *)productId {
  return
      [[[productId stringByReplacingOccurrencesOfString:@"," withString:@"\\,"]
          stringByReplacingOccurrencesOfString:@":"
                                    withString:@"\\:"]
          stringByReplacingOccurrencesOfString:@"&"
                                    withString:@"%26"];
}

+ (nonnull NSArray<NSString *> *)escapeMultiple:
    (nonnull NSArray<NSString *> *)productIds {
  NSMutableArray<NSString *> *results = [NSMutableArray array];
  for (NSString *productId in productIds) {
    [results addObject:[self escape:productId]];
  }
  return results;
}

@end
