//
//  PhotoSizes.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVPhotoSizes.h"
#import "BVNullHelper.h"

@implementation BVPhotoSizes

-(id _Nullable)initWithApiResponse:(id _Nullable)apiResponse {
    
    self = [super init];
    if(self){
        NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*>* apiObject = apiResponse;
        if (apiObject == nil){
            return nil;
        }
        
        SET_IF_NOT_NULL(self.thumbnailUrl, apiObject[@"thumbnail"][@"Url"])
        SET_IF_NOT_NULL(self.normalUrl, apiObject[@"normal"][@"Url"])
    }
    return self;
}

@end
