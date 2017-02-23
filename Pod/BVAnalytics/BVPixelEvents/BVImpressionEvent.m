//
//  BVImpressionEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVImpressionEvent.h"
#import "BVAnalyticEventManager.h"

@implementation BVImpressionEvent

@synthesize additionalParams;

-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                  withContentId:(NSString * _Nonnull)contentId
                 withCategoryId:(NSString * _Nullable)categoryId
         withProductType:(BVPixelProductType)bvProduct
                withContentType:(BVPixelImpressionContentType)contentType
                      withBrand:(NSString * _Nullable)brand
           withAdditionalParams:(NSDictionary * _Nullable)params {
    
    self = [super init];
    
    if (self)
    {
        _productId = productId ? productId: @"unknown";
        _contentId = contentId ? contentId: @"unknown";
        _categoryId = categoryId;
        _bvProduct = bvProduct;
        _contentType = contentType;
        _brand = brand;
        self.additionalParams = params ? params : [NSDictionary dictionary];
    }
    
    return self;
    
}


- (NSDictionary *)toRaw{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.productId, @"productId",
                                      self.contentId, @"contentId",
                                      [BVPixelProductTypeUtil toString:self.bvProduct], @"bvProduct",
                                      [BVPixelImpressionContentTypeUtil toString:self.contentType], @"contentType",
                                      nil];
    
    // Add nullable values
    if (self.categoryId){
        [eventDict addEntriesFromDictionary:@{@"categoryId":self.categoryId}];
    }
    
    if (self.brand){
        [eventDict addEntriesFromDictionary:@{@"brand":self.brand}];
    }
    
    // Common event values implied for schema...
    [eventDict addEntriesFromDictionary:self.additionalParams];
    [eventDict addEntriesFromDictionary:UGC_IMPRESSION_SCHEMA];
    [eventDict addEntriesFromDictionary: [[BVAnalyticEventManager sharedManager] getCommonAnalyticsDictAnonymous:NO]];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
    
}
@end
