//
//  Brand.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBrand.h"
#import "BVNullHelper.h"

@implementation BVBrand

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse {
    
    self = [super init];
    if(self){
        if ([apiResponse isKindOfClass: [NSDictionary class]]){
            NSDictionary* apiObject = (NSDictionary*)apiResponse;
            
            SET_IF_NOT_NULL(self.name, apiObject[@"Name"])
            SET_IF_NOT_NULL(self.identifier, apiObject[@"Id"])
            
        }
        else {
            return nil;
        }
    }
    return self;
    
}

@end
