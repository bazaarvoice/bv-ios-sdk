//
//  SecondaryRatingsAverages.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVSecondaryRatingsAverages.h"
#import "BVNullHelper.h"

@implementation BVSecondaryRatingsAverages

+(BVSecondaryRatingsAverages* _Nullable)createWithDictionary:(id _Nullable)apiResponse {

    if (apiResponse == nil || ![apiResponse isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    
    NSDictionary* apiObject = apiResponse;
    
    for(NSString* key in apiObject){
        NSDictionary* value = apiObject[key];
        id avgRating = value[@"AverageRating"];
        
        if(avgRating != [NSNull null]){
            result[key] = avgRating;
        }
    }
    return (BVSecondaryRatingsAverages*)result;
    
}

@end
