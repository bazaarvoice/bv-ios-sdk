//
//  Transaction.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVTransaction.h"

@implementation BVTransaction

-(id _Nonnull)initWithOrderId:( NSString* _Nonnull )orderId orderTotal:(double)total orderItems:(NSArray* _Nonnull)items andOtherParams:(NSDictionary* _Nullable)params{
    
    NSAssert(orderId,@"orderId cannot be nill");
    NSAssert(items, @"items cannot be nil");
    
    self = [super init];
    
    if (self)
    {
        _orderId = orderId;
        _total = total;
        _items = items;
        _otherParams = params;
    }
    
    return self;
}

@end
