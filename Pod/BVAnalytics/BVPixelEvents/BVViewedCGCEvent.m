//
//  BVViewedCGCEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVViewedCGCEvent.h"
#import "BVPixelTypes.h"
#import "BVAnalyticEventManager.h"

@implementation BVViewedCGCEvent

@synthesize additionalParams;

-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
             withRootCategoryID:(NSString * _Nullable)rootCategoryId
                 withCategoryId:(NSString * _Nullable)categoryId
                withProductType:(BVPixelProductType)bvProduct
                      withBrand:(NSString * _Nullable)brand
           withAdditionalParams:(NSDictionary * _Nullable)params{
    
    self = [super init];
    
    if (self) {
        _productId = productId;
        _brand = brand;
        _bvProduct = bvProduct;
        _categoryId = categoryId;
        _rootCategoryId = rootCategoryId;
        self.additionalParams = [NSDictionary dictionary];
    }
    
    return self;
    
}


- (NSDictionary *)toRaw{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.productId, @"productId",
                                      [BVPixelProductTypeUtil toString:self.bvProduct], @"bvProduct",
                                      nil];
    
    // Add nullable values
    if (self.rootCategoryId){
        [eventDict addEntriesFromDictionary:@{@"rootCategoryId":self.rootCategoryId}];
    }

    
    if (self.categoryId){
        [eventDict addEntriesFromDictionary:@{@"categoryId":self.categoryId}];
    }
    
    if (self.brand){
        [eventDict addEntriesFromDictionary:@{@"brand":self.brand}];
    }
    
    // Common event values implied for schema...
    [eventDict addEntriesFromDictionary:self.additionalParams];
    [eventDict addEntriesFromDictionary:VIEWED_CGC_SCHEMA];
    [eventDict addEntriesFromDictionary: [[BVAnalyticEventManager sharedManager] getCommonAnalyticsDictAnonymous:NO]];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
    
}

@end
