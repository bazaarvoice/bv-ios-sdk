

//
//  BVTransactionItem.h
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVAnalyticEvent.h"
#import <Foundation/Foundation.h>

/// Container class with convenience initializer for required and recommended
/// parameters for items to be included in a Transactional Conversion.
@interface BVTransactionItem : NSObject <BVAnalyticEvent>

/**
@param sku Required - Product External ID.
@param name Recommended - Product name.
@param category Recommended - Product category.
@param price Recommended - Product Price.
@param quantity Recommended - Purchase quantity.
@param imageUrl Recommended - Link to product image.

@return the event object that can be used to submit to Bazaarvoice via the
BVPixel API.
 */
- (nonnull id)initWithSku:(nonnull NSString *)sku
                     name:(nullable NSString *)name
                 category:(nullable NSString *)category
                    price:(double)price
                 quantity:(int)quantity
                 imageUrl:(nullable NSString *)imageUrl;

- (nonnull instancetype)__unavailable init;

/// Product External ID.
@property(nonnull, nonatomic, readonly) NSString *sku;

/// Product name.
@property(nullable, nonatomic, readonly) NSString *name;

/// Product category.
@property(nullable, nonatomic, readonly) NSString *category;

/// Product Price.
@property(nullable, nonatomic, readonly) NSString *imageUrl;

/// Purchase quantity.
@property(nonatomic, assign, readonly) double price;

/// Link to product image.
@property(nonatomic, assign, readonly) int quantity;

@end
