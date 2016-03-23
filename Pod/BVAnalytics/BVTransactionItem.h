//
//  TransactionItem.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/// Container class with convenience initializer for required and recommended parameters for items to be included in a Transactional Conversion.
@interface BVTransactionItem : NSObject

/**
    @param sku Required - Product External ID.
    @param name Recommended - Product name.
    @param category Recommended - Product category.
    @param price Recommended - Product Price.
    @param quantity Recommended - Purchase quantity.
    @param imageUrl Recommended - Link to product image.
 */
-(id _Nonnull)initWithSku:( NSString* _Nonnull )sku name:(NSString* _Nullable)name category:(NSString* _Nullable)category price:(double)price quantity:(int)quantity imageUrl:(NSString* _Nullable)imageUrl;


/// Product External ID.
@property (nonatomic, readonly) NSString* _Nonnull sku;


/// Product name.
@property (nonatomic, readonly) NSString* _Nullable name;


/// Product category.
@property (nonatomic, readonly) NSString* _Nullable category;


/// Product Price.
@property (nonatomic, readonly) NSString* _Nullable imageUrl;


/// Purchase quantity.
@property (nonatomic, assign, readonly) double price;


/// Link to product image.
@property (nonatomic, assign, readonly) int quantity;


@end
