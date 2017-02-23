//
//  BVPageViewEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVPageViewEvent.h"
#import "BVAnalyticEventManager.h"

@implementation BVPageViewEvent

@synthesize additionalParams;

-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
         withBVPixelProductType:(BVPixelProductType)bvProduct
                      withBrand:(NSString * _Nullable)brand
                 withCategoryId:(NSString * _Nullable)categoryId
             withRootCategoryId:(NSString * _Nullable)rootCategoryId
           withAdditionalParams:(NSDictionary * _Nullable)params;
{
    
    NSAssert(productId, @"productId cannot be nil");
    
    self = [super init];
    
    if (self)
    {
        _productId = productId == nil ? @"unknown" : productId;
        _bvProduct = bvProduct;
        _brand = brand;
        _categoryId = categoryId;
        _rootCategoryId = rootCategoryId;
        self.additionalParams = params ? params : [NSDictionary dictionary];
    }
    
    return self;
    
}

- (NSDictionary  *)toRaw {

    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.productId, @"productId",
                                      [BVPixelProductTypeUtil toString:self.bvProduct], @"bvProduct",
                                      nil];
    
    // Add nullable values
    if (self.categoryId){
        [eventDict addEntriesFromDictionary:@{@"categoryId":self.categoryId}];
    }
    
    if (self.rootCategoryId){
        [eventDict addEntriesFromDictionary:@{@"rootCategoryId":self.rootCategoryId}];
    }
    
    if (self.brand){
        [eventDict addEntriesFromDictionary:@{@"brand":self.brand}];
    }
    
    // Common event values implied for schema...
    [eventDict addEntriesFromDictionary:self.additionalParams];
    [eventDict addEntriesFromDictionary:PRODUCT_PAGEVIEW_SCHEMA];
    [eventDict addEntriesFromDictionary: [[BVAnalyticEventManager sharedManager] getCommonAnalyticsDictAnonymous:NO]];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
}

@end
