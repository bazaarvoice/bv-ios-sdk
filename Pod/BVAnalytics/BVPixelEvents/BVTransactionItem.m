//
//  BVTransactionItem.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVTransactionItem.h"

@implementation BVTransactionItem

@synthesize additionalParams;

- (nonnull id)initWithSku:(nonnull NSString *)sku
                     name:(nullable NSString *)name
                 category:(nullable NSString *)category
                    price:(double)price
                 quantity:(int)quantity
                 imageUrl:(nullable NSString *)imageUrl {

  NSAssert(sku, @"SKU cannot be nil");

  self = [super init];

  if (self) {
    _sku = sku;
    _name = name;
    _category = category;
    _imageUrl = imageUrl;
    _price = price;
    _quantity = quantity;
    self.additionalParams = [NSDictionary dictionary];
  }

  return self;
}

- (NSDictionary *)toRaw {

  NSMutableDictionary *eventDict =
      [NSMutableDictionary dictionaryWithObjectsAndKeys:self.sku, @"sku", nil];

  // Add nullable values
  if (self.name) {
    [eventDict setObject:self.name forKey:@"name"];
  }

  if (self.imageUrl) {
    [eventDict setObject:self.imageUrl forKey:@"imageUrl"];
  }

  if (self.category) {
    [eventDict setObject:self.category forKey:@"category"];
  }

  [eventDict setObject:[NSString stringWithFormat:@"%d", self.quantity]
                forKey:@"quantity"];
  [eventDict setObject:[NSString stringWithFormat:@"%0.2f", self.price]
                forKey:@"price"];

  // Common event values implied for schema...
  [eventDict addEntriesFromDictionary:self.additionalParams];
  return [NSDictionary dictionaryWithDictionary:eventDict];
}

@end
