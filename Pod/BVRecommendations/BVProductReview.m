//
//  BVProductReview.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVCore.h"
#import "BVProductReview.h"

@implementation BVProductReview

-(id)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if(self) {
        
        if(dict != nil && ![dict isKindOfClass:[NSNull class]]){
            
            SET_IF_NOT_NULL(self.reviewText, [dict objectForKey:@"text"]);
            SET_IF_NOT_NULL(self.reviewTitle, [dict objectForKey:@"title"]);
            SET_IF_NOT_NULL(self.reviewAuthorName, [dict objectForKey:@"authorName"]);
        }
        
    }
    return self;
}

@end
