//
//  BVBasePIIEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVBasePIIEvent.h"
#import "BVRandom+NSString.h"

__strong static NSSet *whitelistParams;

@implementation BVBasePIIEvent

@synthesize additionalParams;

- (instancetype)initWithParams:(nullable NSDictionary *)params {
  if ((self = [super init])) {
    // these are considered the only non-PII params
    whitelistParams = [[NSSet alloc]
        initWithObjects:@"orderId", @"affiliation", @"total", @"tax",
                        @"shipping", @"city", @"state", @"country", @"currency",
                        @"items", @"locale", @"discount", @"type", @"label", @"value",
                        @"proxy", @"partnerSource", @"deploymentZone", @"TestCase", @"TestSession",
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
  return [NSString randomHexStringWithLength:20];
}

@end
