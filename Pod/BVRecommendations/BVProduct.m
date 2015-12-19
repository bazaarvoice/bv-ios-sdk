//
//  BVProduct.m
//  Bazaarvoice SDK
//
//  Copyright 2015 Bazaarvoice Inc. All rights reserved.
//

#import "BVProduct.h"

#define SET_IF_NOT_NULL(target, value) if(value != [NSNull null]) { target = value; }

@implementation BVProduct

- (id)initWithDictionary:(NSDictionary *)dict withProductKey:(NSString *)key withRecStats:(NSDictionary *)stats{
    
    self = [super init];
    
    self.product_key = key;
    
    SET_IF_NOT_NULL(self.client, [dict objectForKey:@"client"]);
    SET_IF_NOT_NULL(self.product_description, [dict objectForKey:@"description"]);
    SET_IF_NOT_NULL(self.name, [dict objectForKey:@"name"]);
    
    SET_IF_NOT_NULL(self.product_id, [dict objectForKey:@"product"]);
    SET_IF_NOT_NULL(self.product_page_url, [dict objectForKey:@"product_page_url"]);
    
    SET_IF_NOT_NULL(self.image_url, [dict objectForKey:@"image_url"]);
    
    SET_IF_NOT_NULL(self.client_id, [dict objectForKey:@"client"]);
    
    SET_IF_NOT_NULL(self.reviewText, [[dict objectForKey:@"review"] objectForKey:@"text"]);
    SET_IF_NOT_NULL(self.reviewTitle, [[dict objectForKey:@"review"] objectForKey:@"title"]);
    
    if ([dict objectForKey:@"avg_rating"]){
        self.avg_rating =  [NSNumber numberWithFloat:[[dict objectForKey:@"avg_rating"] floatValue]];
    }
    
    if ([dict objectForKey:@"num_reviews"]){
        self.num_reviews = [NSNumber numberWithInteger:[[dict objectForKey:@"num_reviews"] integerValue]];
    }
    
    SET_IF_NOT_NULL(self.price, [dict objectForKey:@"price"]);
    if (!self.price){
        self.price = @"";
    }
    
    SET_IF_NOT_NULL(self.price, [dict objectForKey:@"authorName"]);
    SET_IF_NOT_NULL(self.price, [dict objectForKey:@"authorLocation"]);
    
    if (!self.reviewAuthor){
        self.reviewAuthor = @"";
    }
    
    if (!self.reviewAuthorLocation){
        self.reviewAuthorLocation = @"";
    }
    
    self.sponsored = [NSNumber numberWithBool:NO];
    if ([dict objectForKey:@"sponsored"] && [[dict objectForKey:@"sponsored"] integerValue] == 1){
        self.sponsored = [NSNumber numberWithBool:YES];
    }
    
    SET_IF_NOT_NULL(self.RS, [dict objectForKey:@"RS"]);
    
    self.RKB = [NSNumber numberWithInt:0];
    self.RKI = [NSNumber numberWithInt:0];
    self.RKP = [NSNumber numberWithInt:0];
   
    if (stats){
        if ([stats objectForKey:@"RKB"]){
            self.RKB = [NSNumber numberWithInteger:[[stats objectForKey:@"RKB"] integerValue]];
        }
        if ([stats objectForKey:@"RKI"]){
            self.RKI = [NSNumber numberWithInteger:[[stats objectForKey:@"RKI"] integerValue]];
        }
        if ([stats objectForKey:@"RKP"]){
            self.RKP = [NSNumber numberWithInteger:[[stats objectForKey:@"RKP"] integerValue]];
        }
    }
    
    return self;
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"BVProduct: KEY:%@ NAME:%@", self.product_key, self.name];
}

@end
