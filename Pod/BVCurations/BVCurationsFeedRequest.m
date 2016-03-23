//
//  BVCurationsFeedRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsFeedRequest.h"

@implementation BVCurationsFeedRequest

- (id)initWithGroups:(NSArray<NSString *>*)groups {
    
    self = [super init];
    
    if (self){
        _limit = 10;
        _after = [NSNumber numberWithLong:0];
        _before = [NSNumber numberWithLong:0];
        _groups = groups;
    }
    
    return self;
}


- (NSArray *)createQueryItems{
    
    // Check for the required params, fail if not present
    NSAssert([self.groups count] > 0, @"You must supply at least one item in the groups parameter.");
    
    BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
    NSString *clientId = sdkMgr.clientId;
    NSString *apiKey = sdkMgr.apiKeyCurations;
    
    NSAssert(apiKey != nil && ![apiKey isEqualToString:@""], @"apiKeyCurations must be set on BVSDKManager before using the Curations SDK.");
    
    
    // Build up the query parameters...
    
    if (self.limit > 100) self.limit = 20;
    
    NSURLQueryItem *search  = [NSURLQueryItem queryItemWithName:@"passkey" value:apiKey];
    NSURLQueryItem *client  = [NSURLQueryItem queryItemWithName:@"client"  value:clientId];
    NSURLQueryItem *limit   = [NSURLQueryItem queryItemWithName:@"limit"   value:[NSString stringWithFormat:@"%lu", (unsigned long)self.limit]];
    
    // Add the required/default query params
    
    NSMutableArray* queryItems = [NSMutableArray arrayWithArray:@[ search, client, limit ]];
    
    // groups array -- one parame per value (i.e. cannot be comma-delimited)
    for (NSString* groupString in self.groups) {
        NSURLQueryItem *group = [NSURLQueryItem queryItemWithName:@"groups"  value:groupString];
        [queryItems addObject:group];
    }
    
    // Add the optional query params...
    
    // tags array
    for (NSString* tagString in self.tags) {
        NSURLQueryItem *tag = [NSURLQueryItem queryItemWithName:@"tags"  value:tagString];
        [queryItems addObject:tag];
    }
    
    if ([self.before integerValue] > 0){
        NSURLQueryItem *beforeQI = [NSURLQueryItem queryItemWithName:@"before" value:[NSString stringWithFormat:@"%li", (long)[self.before integerValue]]];
        [queryItems addObject:beforeQI];
    }
    
    
    if ([self.after integerValue] > 0){
        NSURLQueryItem *afterQI = [NSURLQueryItem queryItemWithName:@"after" value:[NSString stringWithFormat:@"%li", (long)[self.after integerValue]]];
        [queryItems addObject:afterQI];
    }
    
    if (self.author != nil){
        NSURLQueryItem *authorQI = [NSURLQueryItem queryItemWithName:@"author" value:self.author];
        [queryItems addObject:authorQI];
    }
    
    if (self.featured > 0){
        NSURLQueryItem *featuredQI = [NSURLQueryItem queryItemWithName:@"featured" value:[NSString stringWithFormat:@"%lu", (unsigned long)self.featured ]];
        [queryItems addObject:featuredQI];
    }
    
    if (self.hasGeotag){
        NSURLQueryItem *hasGeoTagQI = [NSURLQueryItem queryItemWithName:@"has_geotag" value:@"true"];
        [queryItems addObject:hasGeoTagQI];
    }
    
    if (self.hasLink){
        NSURLQueryItem *hasLinkQI = [NSURLQueryItem queryItemWithName:@"has_link" value:@"true"];
        [queryItems addObject:hasLinkQI];
    }
    
    if (self.hasPhoto){
        NSURLQueryItem *hasPhotoQI = [NSURLQueryItem queryItemWithName:@"has_photo" value:@"true"];
        [queryItems addObject:hasPhotoQI];
    }
    
    if (self.hasVideo){
        NSURLQueryItem *hasVideoQI = [NSURLQueryItem queryItemWithName:@"has_video" value:@"true"];
        [queryItems addObject:hasVideoQI];
    }
    
    if (self.withProductData){
        NSURLQueryItem *withProductDataQI = [NSURLQueryItem queryItemWithName:@"withProductData" value:@"true"];
        [queryItems addObject:withProductDataQI];
    }
    
    if (self.includeComments){
        NSURLQueryItem *includeCommentsQI = [NSURLQueryItem queryItemWithName:@"include_comments" value:@"true"];
        [queryItems addObject:includeCommentsQI];
    }
    
    if (self.perGroupLimit > 0){
        NSURLQueryItem *perGroupLimitQI = [NSURLQueryItem queryItemWithName:@"per_group_limit" value:[NSString stringWithFormat:@"%lu", (unsigned long)self.perGroupLimit]];
        [queryItems addObject:perGroupLimitQI];
    }
    
    if (self.externalId){
        NSURLQueryItem *externalIdQI = [NSURLQueryItem queryItemWithName:@"externalId" value:self.externalId];
        [queryItems addObject:externalIdQI];
    }
    
    if (self.explicitPermission){
        NSURLQueryItem *explicitPermissionQI = [NSURLQueryItem queryItemWithName:@"explicit_permission" value:@"true"];
        [queryItems addObject:explicitPermissionQI];
    }
    
    if (self.media) {
        
        NSError *error;
        NSData *jsonMediaData = [NSJSONSerialization dataWithJSONObject:self.media
                                                           options:0
                                                             error:&error];
        
        if (!jsonMediaData || error != nil) {
            [[BVLogger sharedLogger] error:@"Unable to parameterize media dictionary for curations request."];
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonMediaData encoding:NSUTF8StringEncoding];
            NSURLQueryItem *mediaQueryQI = [NSURLQueryItem queryItemWithName:@"media" value:jsonString];
            [queryItems addObject:mediaQueryQI];
        }
        
    }
    
    return queryItems;
}

@end
