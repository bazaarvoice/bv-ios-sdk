//
//  ContextDataValue.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVContextDataValue.h"
#import "BVNullHelper.h"

@implementation BVContextDataValue

-(id)initWithApiResponse:(NSDictionary* _Nonnull)apiResponse {
    self = [super init];
    if(self) {
        SET_IF_NOT_NULL(self.value, apiResponse[@"Value"])
        SET_IF_NOT_NULL(self.valueLabel, apiResponse[@"ValueLabel"])
        SET_IF_NOT_NULL(self.dimensionLabel, apiResponse[@"DimensionLabel"])
        SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
    }
    return self;
}

@end
