//
//  BVConversionEvent.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVConversionEvent.h"
#import "BVAnalyticEventManager+Private.h"

@implementation BVConversionEvent

@synthesize additionalParams;

- (nonnull id)initWithType:(nonnull NSString *)type
                     value:(nonnull NSString *)value
                     label:(nullable NSString *)label
               otherParams:(nullable NSDictionary *)params {

  NSAssert(type && 0 < type.length, @"You must provide a type");
  NSAssert(value && 0 < value.length, @"You must provide a value");

  if ((self = [super initWithParams:params])) {
    _type = type;
    _value = value;
    _label = label;
    self.additionalParams = params ? params : [NSDictionary dictionary];
  }
  return self;
}

- (NSDictionary *)toRaw {
  NSMutableDictionary *eventDict;

  if ([self hasPII]) {
    eventDict = [self createBaseEvent:YES];
    [eventDict addEntriesFromDictionary:CONVERSION_SCHEMA_PII];
    [eventDict setObject:@"true" forKey:@"hadPII"];
  } else {
    eventDict = [self createBaseEvent:NO];
    [eventDict addEntriesFromDictionary:CONVERSION_SCHEMA];
  }

  [eventDict addEntriesFromDictionary:self.additionalParams];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}

- (NSDictionary *)toRawNonPII {
  NSMutableDictionary *eventDict = [self createBaseEvent:NO];

  if ([self hasPII]) {
    [eventDict setObject:@"true" forKey:@"hadPII"];
  }

  NSDictionary *nonPIIParams =
      [self getNonPII:self.additionalParams]; // strip out any non-whitelisted
                                              // params that may contain
                                              // personal identifiers

  [eventDict addEntriesFromDictionary:nonPIIParams];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}

- (NSMutableDictionary *)createBaseEvent:(BOOL)anonymous {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.type, @"type", self.value, @"value",
                                   nil];

  // Add nullable values
  if (self.label) {
    [eventDict setObject:self.label forKey:@"label"];
  }

  // Common event values implied for schema...
  [eventDict setObject:[self getLoadId] forKey:@"loadId"];
  [eventDict
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDictAnonymous:anonymous]];

  return eventDict;
}

@end
