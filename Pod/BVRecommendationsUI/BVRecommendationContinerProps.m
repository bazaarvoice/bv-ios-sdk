//
//  BVRecommendationContinerProps.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVRecommendationContinerProps.h"
#import "BVShopperProfileRequestCache.h"

@implementation BVRecommendationContinerProps

- (id)init{
    
    self = [super init];
    if (self){
        
        // set default recommendation parameters
        _categoryId = nil;
        _productId = nil;
        _maxAgeCache = 60;
        _recommendationLimit = 20;
    }
    return self;
    
}

-(void)setMaxAgeCache:(NSUInteger)maxAgeCache{
    
    _maxAgeCache = maxAgeCache;
    [BVShopperProfileRequestCache sharedCache].cacheMaxAgeInSeconds = _maxAgeCache;
    
}

@end
