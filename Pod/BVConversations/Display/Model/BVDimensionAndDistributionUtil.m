//
//  DimensionAndDistributionUtil.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVDimensionAndDistributionUtil.h"

@implementation BVDimensionAndDistributionUtil

+(TagDistribution _Nullable)createDistributionWithApiResponse:(id _Nullable)apiResponse {
    
    
    NSDictionary<NSString*, NSDictionary*>* apiObject = apiResponse;
    if(apiObject == nil){
        return nil;
    }
    
    TagDistribution tempValues = [NSMutableDictionary dictionary];
    for(NSString* key in apiObject) {
        NSDictionary* value = [apiObject objectForKey:key];
        BVDistributionElement* element = [[BVDistributionElement alloc] initWithApiResponse:value];
        [tempValues setObject:element forKey:key];
    }
    
    return tempValues;
    
}

@end
