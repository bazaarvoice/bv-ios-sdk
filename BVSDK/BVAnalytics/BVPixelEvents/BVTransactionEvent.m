//
//  BVTransactionEvent.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVTransactionEvent.h"
#import "BVAnalyticEventManager+Private.h"

@implementation BVTransactionEvent

- (nonnull id)initWithOrderId:(nonnull NSString *)orderId
                   orderTotal:(double)total
                   orderItems:(nonnull NSArray *)items
               andOtherParams:(nullable NSDictionary *)params {
  NSAssert(orderId, @"orderId cannot be nil");
  NSAssert(items, @"items cannot be nil");

  if ((self = [super initWithParams:params])) {
    _orderId = orderId;
    _total = total;
    _items = items;
  }
  return self;
}

- (NSDictionary *)toRaw {
  NSMutableDictionary *eventDict;

  if ([self hasPII]) {
    eventDict = [self crateBaseEvent:YES];
    [eventDict addEntriesFromDictionary:TRANSACTION_SCHEMA_PII];
    [eventDict setObject:@"true" forKey:@"hadPII"];
  } else {
    eventDict = [self crateBaseEvent:NO];
    [eventDict addEntriesFromDictionary:TRANSACTION_SCHEMA];
  }

  [eventDict addEntriesFromDictionary:self.additionalParams];

  return [NSDictionary dictionaryWithDictionary:eventDict];
}

- (NSDictionary *)toRawNonPII {
  NSMutableDictionary *eventDict = [self crateBaseEvent:NO];

  [eventDict addEntriesFromDictionary:TRANSACTION_SCHEMA];

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

// All transaction events are created from a base set of properties.
- (NSMutableDictionary *)crateBaseEvent:(BOOL)anonymous {
  NSMutableDictionary *eventDict = [NSMutableDictionary
      dictionaryWithObjectsAndKeys:self.orderId, @"orderId", nil];

  [eventDict setObject:[NSString stringWithFormat:@"%0.2f", self.total]
                forKey:@"total"];

  // Add nullable values
  if (self.tax) {
    [eventDict setObject:[NSString stringWithFormat:@"%0.2f", self.tax]
                  forKey:@"tax"];
  }

  if (self.shipping) {
    [eventDict setObject:[NSString stringWithFormat:@"%0.2f", self.shipping]
                  forKey:@"shipping"];
  }

  if (self.city) {
    [eventDict setObject:self.city forKey:@"city"];
  }

  if (self.state) {
    [eventDict setObject:self.state forKey:@"state"];
  }

  if (self.country) {
    [eventDict setObject:self.country forKey:@"country"];
  }

  if (self.currency) {
    [eventDict setObject:self.currency forKey:@"currency"];
  }

  // convert and add Transaction Items
  NSMutableArray *serializedItems = [NSMutableArray new];
  for (BVTransactionItem *item in self.items) {
    NSDictionary *itemParams = [item toRaw];
    [serializedItems addObject:itemParams];
  }

  [eventDict setObject:serializedItems forKey:@"items"];

  // Common event values implied for schema...
  [eventDict setObject:[self getLoadId] forKey:@"loadId"];
  [eventDict
      addEntriesFromDictionary:[[BVAnalyticEventManager sharedManager]
                                   getCommonAnalyticsDictAnonymous:anonymous]];

  return eventDict;
}

@end
