//
//  TransactionItem.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVTransactionItem.h"

@implementation BVTransactionItem

-(id _Nonnull)initWithSku:( NSString* _Nonnull )sku name:(NSString* _Nullable)name category:(NSString* _Nullable)category price:(double)price quantity:(int)quantity imageUrl:(NSString* _Nullable)imageUrl{
    
    NSAssert(sku, @"SKU cannot be nil");
    
    self = [super init];
    
    if (self) {
        _sku = sku;
        _name = name;
        _category = category;
        _imageUrl = imageUrl;
        _price = price;
        _quantity = quantity;
    }
    
    return self;
}

@end
