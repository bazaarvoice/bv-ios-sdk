//
//  BVShopperProfile.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVShopperProfile.h"



@interface BVShopperProfile ()

@property (strong, nonatomic) NSDictionary *recommendationStats;

@end

@implementation BVShopperProfile


- (id)init{
    
    self = [super init];
    
    self.brands = [NSDictionary dictionary];
    self.interests = [NSDictionary dictionary];
    self.recommendations = [NSArray array];
    self.product_keys = [NSSet set];
    
    self.recommendationStats = [NSDictionary dictionary];
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)apiResponse{
    
    self = [self init];
    
    NSDictionary *profile = [apiResponse objectForKey:@"profile"];
    
    if (profile){
        
        self.brands = [profile objectForKey:@"brands"];
        
        self.userId = [profile objectForKey:@"id"];
        
        self.interests = [profile objectForKey:@"interests"];
        
        self.recommendationStats = [profile objectForKey:@"recommendationStats"];
        
        //NSArray *recommendationProductIds = [profile objectForKey:@"recommendations"];
        NSDictionary *productsDict = [profile objectForKey:@"products"];
        
        NSMutableArray *tmp = [NSMutableArray array];
        if (productsDict){
            
            for (NSString* productKey in productsDict) {
                
                NSDictionary *oneProdDict = [productsDict objectForKey:productKey];
                BVProduct *product = [[BVProduct alloc] initWithDictionary:oneProdDict withProductKey:productKey withRecStats:self.recommendationStats];
                
                if (product){
                    [tmp addObject:product];
                }
            }
        }
        
        self.recommendations = [NSArray arrayWithArray:tmp];
        
        if ([profile objectForKey:@"recommendations"]){
            self.product_keys = [NSSet setWithArray:[profile objectForKey:@"recommendations"]];
        }
    }
    
    return self;
    
}

- (nullable BVProduct *)productFromKey:(NSString *)productKey{
    
    BVProduct *product = nil;
    
    for (BVProduct *prod in self.recommendations){
        
        if ([productKey isEqualToString:prod.product_key]){
            product = prod;
        }
        
    }
    
    return product;
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"BVShopperProfile: ID:%@", self.userId];
    
}

@end
