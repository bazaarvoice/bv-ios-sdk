//
//  BVModelUtil.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVModelUtil.h"

@implementation BVModelUtil


+ (NSDate * _Nullable)convertTimestampToDatetime:(id _Nullable)timestamp {
    
    if (timestamp == nil || ![timestamp isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString* timestampString = timestamp;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSX"]; // UTC format
    return [dateFormatter dateFromString:timestampString];
    
}


+ (NSArray<BVPhoto *> * _Nonnull)parsePhotos:(id _Nullable)apiResponse {
    
    NSMutableArray<BVPhoto*>* tempValues = [NSMutableArray array];

    for(NSDictionary* photo in apiResponse) {
        [tempValues addObject:[[BVPhoto alloc] initWithApiResponse:photo]];
    }
    return tempValues;
    
}

+ (NSArray<BVVideo *> * _Nonnull)parseVideos:(id _Nullable)apiResponse {
    
    NSMutableArray<BVVideo*>* tempValues = [NSMutableArray array];
    
    for(NSDictionary* photo in apiResponse) {
        [tempValues addObject:[[BVVideo alloc] initWithApiResponse:photo]];
    }
    return tempValues;
    
}
+ (NSArray<BVContextDataValue *> * _Nonnull)parseContextDataValues:(id _Nullable)apiResponse {
    
    NSMutableArray<BVContextDataValue*>* tempValues = [NSMutableArray array];
    NSDictionary* apiObject = apiResponse;
    for(NSString* key in apiObject){
        NSDictionary* value = [apiObject objectForKey:key];
        [tempValues addObject:[[BVContextDataValue alloc] initWithApiResponse:value]];
    }
    return tempValues;
    
}

+ (NSArray<BVBadge *> * _Nonnull)parseBadges:(id _Nullable)apiResponse {
    
    NSMutableArray<BVBadge*>* tempValues = [NSMutableArray array];
    NSDictionary* apiObject = apiResponse;
    for(NSString* key in apiObject){
        NSDictionary* value = [apiObject objectForKey:key];
        [tempValues addObject:[[BVBadge alloc] initWithApiResponse:value]];
    }
    return tempValues;
    
}
+ (NSArray<BVSecondaryRating *> * _Nonnull)parseSecondaryRatings:(id _Nullable)apiResponse {
    
    NSMutableArray<BVSecondaryRating*>* tempValues = [NSMutableArray array];
    NSDictionary* apiObject = apiResponse;
    for(NSString* key in apiObject){
        NSDictionary* value = [apiObject objectForKey:key];
        [tempValues addObject:[[BVSecondaryRating alloc] initWithApiResponse:value]];
    }
    return tempValues;
    
}
+ (TagDimensions _Nullable)parseTagDimension:(id _Nullable)apiResponse {
    
    TagDimensions tempResult = [NSMutableDictionary dictionary];
    NSDictionary* apiObject = apiResponse;
    for(NSString* key in apiObject){
        NSDictionary* value = [apiObject objectForKey:key];
        [tempResult setObject:[[BVDimensionElement alloc] initWithApiResponse:value] forKey:key];
    }
    return tempResult;
    
}

@end
