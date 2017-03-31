//
//  BVPIN.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVPIN.h"

@implementation BVPIN
@synthesize displayName;
@synthesize displayImageUrl;
@synthesize identifier = _identifier;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _averageRating = dictionary[@"avg_rating"];
        _imageUrl = dictionary[@"image_url"];
        _productPageURL = dictionary[@"product_page_url"];
        _name = dictionary[@"name"];
        _identifier = dictionary[@"id"];
    }
    
    return self;
}

-(NSString*)displayName {
    return _name;
}

-(NSString*)displayImageUrl {
    return _imageUrl;
}

@end
