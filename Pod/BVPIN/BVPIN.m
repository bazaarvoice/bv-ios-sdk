//
//  BVPIN.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVPIN.h"

@implementation BVPIN

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _averageRating = dictionary[@"avg_rating"];
        _imageUrl = dictionary[@"image_url"];
        _productPageURL = dictionary[@"product_page_url"];
        _name = dictionary[@"name"];
        _ID = dictionary[@"id"];
    }
    
    return self;
}

@end
