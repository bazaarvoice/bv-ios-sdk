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
        
        if (!isObjectNilOrNull(apiObject[@"thumbnail"][@"Url"])){
            self.thumbnailUrl = apiObject[@"thumbnail"][@"Url"];
        }
        
        if (!isObjectNilOrNull(apiObject[@"normal"][@"Url"])){
            self.normalUrl = apiObject[@"normal"][@"Url"];
        }
        
    }
    return self;
}

@end
