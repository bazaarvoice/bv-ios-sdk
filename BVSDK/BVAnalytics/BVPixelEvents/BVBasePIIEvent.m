//
//  BVBasePIIEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBasePIIEvent.h"

__strong static NSSet *whitelistParams;

@implementation BVBasePIIEvent

@synthesize additionalParams;

- (instancetype)initWithParams:(nullable NSDictionary *)params {
  self = [super init];

  if (self) {
    sranddev();
    // these are considered the only non-PII params
    whitelistParams = [[NSSet alloc]
        initWithObjects:@"orderId", @"affiliation", @"total", @"tax",
                        @"shipping", @"city", @"state", @"country", @"currency",
                        @"items", @"locale", @"type", @"label", @"value",
                        @"proxy", @"partnerSource", @"TestCase", @"TestSession",
                        @"dc", @"ref", nil];

    self.additionalParams = params ? params : [NSDictionary dictionary];
  }

  return self;
}

- (NSDictionary *)toRaw {
  NSAssert(NO, @"Should be implemented only by subclass");
  return nil;
}

- (NSDictionary *)getNonPII:(nullable NSDictionary *)params {
  NSMutableDictionary *nonPIIParmas = [NSMutableDictionary new];

  if (params) {
    for (NSString *key in params.allKeys) {
      if ([whitelistParams containsObject:key]) {
        [nonPIIParmas setObject:params[key] forKey:key];
      }
    }
  }
  return nonPIIParmas;
}

- (BOOL)hasPII {
  NSDictionary *nonPIIParams = [self getNonPII:self.additionalParams];
  return nonPIIParams.count != self.additionalParams.count;
}

- (NSString *)getLoadId {
  int charLimit = 20;
  NSMutableString *loadId = [NSMutableString new];

  while (loadId.length < charLimit) {
    [loadId appendFormat:@"%x", rand() % 16];
  }

  return loadId;
}

@end
