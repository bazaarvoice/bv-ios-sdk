//
//  BVProduct.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVProduct.h"

@implementation BVProduct

- (id)initWithDictionary:(NSDictionary *)dict withRecommendationStats:(NSDictionary*)recommendationStats{
    
    self = [super init];
    
    NSMutableDictionary* combinedDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    [combinedDictionary addEntriesFromDictionary:recommendationStats];
    self.rawProductDict = combinedDictionary;
    
    SET_IF_NOT_NULL(self.productName, [dict objectForKey:@"name"]);
    SET_IF_NOT_NULL(self.productId, [dict objectForKey:@"product"]);
    SET_IF_NOT_NULL(self.productPageURL, [dict objectForKey:@"product_page_url"]);
    SET_IF_NOT_NULL(self.imageURL, [dict objectForKey:@"image_url"]);
    SET_IF_NOT_NULL(self.averageRating, [dict objectForKey:@"avg_rating"]);
    SET_IF_NOT_NULL(self.numReviews, [dict objectForKey:@"num_reviews"]);
    SET_IF_NOT_NULL(self.price, [dict objectForKey:@"price"]);
    
    self.review = [[BVProductReview alloc] initWithDict:[dict objectForKey:@"review"]];
    
    self.sponsored = false;
    if ([dict objectForKey:@"sponsored"] && [[dict objectForKey:@"sponsored"] integerValue] == 1){
        self.sponsored = true;
    }
        
    return self;
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"BVProduct: %@ - id: %@", self.productName, self.productId];
}

@end
