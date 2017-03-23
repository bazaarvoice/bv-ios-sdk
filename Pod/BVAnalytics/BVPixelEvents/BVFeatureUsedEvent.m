//
//  BVFeatureUsedEvent.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVFeatureUsedEvent.h"
#import "BVAnalyticEventManager.h"

@implementation BVFeatureUsedEvent

@synthesize additionalParams;

-(id _Nonnull)initWithProductId:(NSString * _Nonnull)productId
                      withBrand:(NSString * _Nullable)brand
         withProductType:(BVPixelProductType)bvProduct
            withEventName:(BVPixelFeatureUsedEventName)eventName
           withAdditionalParams:(NSDictionary * _Nullable)params{
    
    self = [super init];
    
    if (self)
    {
        _productId = productId ? productId: @"unknown";
        _brand = brand;
        _bvProduct = bvProduct;
        _eventName = eventName;
        self.additionalParams = params ? params : [NSDictionary dictionary];
    }
    
    return self;
}

- (NSDictionary *)toRaw{
    
    NSMutableDictionary *eventDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      self.productId, @"productId",
                                      [BVPixelProductTypeUtil toString:self.bvProduct], @"bvProduct",
                                      [BVPixelFeatureUsedEventNameUtil toString:self.eventName], @"name",
                                      nil];
    
    // Add nullable values
    if (self.brand){
        [eventDict addEntriesFromDictionary:@{@"brand":self.brand}];
    }
    
    if (_eventName == BVPixelFeatureUsedEventNameInView){
        [eventDict addEntriesFromDictionary:@{@"interaction":@"false"}];
    } else {
        [eventDict addEntriesFromDictionary:@{@"interaction":@"true"}];
    }
    
    // Common event values implied for schema...
    [eventDict addEntriesFromDictionary:self.additionalParams];
    [eventDict addEntriesFromDictionary:USED_FEATURE_SCHEMA];
    [eventDict addEntriesFromDictionary: [[BVAnalyticEventManager sharedManager] getCommonAnalyticsDictAnonymous:NO]];
    
    return [NSDictionary dictionaryWithDictionary:eventDict];
}

@end
