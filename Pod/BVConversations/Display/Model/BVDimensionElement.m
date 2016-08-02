//
//  DimensionElement.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionElement.h"
#import "BVNullHelper.h"

@implementation BVDimensionElement

-(id _Nonnull)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse {
    
    self = [super init];
    if(self){
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
        SET_IF_NOT_NULL(self.label, apiResponse[@"Label"])
        SET_IF_NOT_NULL(self.values, apiResponse[@"Values"])
    }
    return self;
}

@end
