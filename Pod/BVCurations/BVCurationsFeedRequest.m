//
//  BVCurationsFeedRequest.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVCurationsFeedRequest.h"
#import "BVSDKConfiguration.h"

@interface BVCurationsFeedRequest ()

@property NSNumber *latitude;
@property NSNumber *longitude;

@end

@implementation BVCurationsFeedRequest

- (id)initWithGroups:(NSArray<NSString *> *)groups {

  self = [super init];

  if (self) {
    _limit = 10;
    _after = [NSNumber numberWithLong:0];
    _before = [NSNumber numberWithLong:0];
    _groups = groups;
  }

  return self;
}

- (void)setLatitude:(double)latitude longitude:(double)longitude {

  self.latitude = [NSNumber numberWithDouble:latitude];
  self.longitude = [NSNumber numberWithDouble:longitude];
}

- (NSArray *)createQueryItems {

  // Check for the required params, fail if not present
  NSAssert([self.groups count] > 0,
           @"You must supply at least one item in the groups parameter.");

  BVSDKManager *sdkMgr = [BVSDKManager sharedManager];
  NSString *clientId = sdkMgr.configuration.clientId;
  NSString *apiKey = sdkMgr.configuration.apiKeyCurations;

  NSAssert(apiKey.length, @"apiKeyCurations must be set on BVSDKManager before "
                          @"using the Curations SDK.");

  // Build up the query parameters...

  if (self.limit > 100)
    self.limit = 20;

  NSURLQueryItem *search =
      [NSURLQueryItem queryItemWithName:@"passkey" value:apiKey];
  NSURLQueryItem *client =
      [NSURLQueryItem queryItemWithName:@"client" value:clientId];
  NSURLQueryItem *limit = [NSURLQueryItem
      queryItemWithName:@"limit"
                  value:[NSString stringWithFormat:@"%lu",
                                                   (unsigned long)self.limit]];

  // Add the required/default query params

  NSMutableArray *queryItems =
      [NSMutableArray arrayWithArray:@[ search, client, limit ]];

  // groups array -- one parame per value (i.e. cannot be comma-delimited)
  for (NSString *groupString in self.groups) {
    NSURLQueryItem *group =
        [NSURLQueryItem queryItemWithName:@"groups" value:groupString];
    [queryItems addObject:group];
  }

  // Add the optional query params...

  // geolocation, if available
  if (self.latitude != nil && self.longitude != nil) {
    NSString *paramString =
        [NSString stringWithFormat:@"%@,%@", self.latitude, self.longitude];
    NSURLQueryItem *geolocation =
        [NSURLQueryItem queryItemWithName:@"geolocation" value:paramString];
    [queryItems addObject:geolocation];
  }

  // tags array
  for (NSString *tagString in self.tags) {
    NSURLQueryItem *tag =
        [NSURLQueryItem queryItemWithName:@"tags" value:tagString];
    [queryItems addObject:tag];
  }

  if ([self.before integerValue] > 0) {
    NSURLQueryItem *beforeQI = [NSURLQueryItem
        queryItemWithName:@"before"
                    value:[NSString
                              stringWithFormat:@"%li",
                                               (long)
                                                   [self.before integerValue]]];
    [queryItems addObject:beforeQI];
  }

  if ([self.after integerValue] > 0) {
    NSURLQueryItem *afterQI = [NSURLQueryItem
        queryItemWithName:@"after"
                    value:[NSString
                              stringWithFormat:@"%li",
                                               (long)
                                                   [self.after integerValue]]];
    [queryItems addObject:afterQI];
  }

  if (self.author != nil) {
    NSURLQueryItem *authorQI =
        [NSURLQueryItem queryItemWithName:@"author" value:self.author];
    [queryItems addObject:authorQI];
  }

  if (self.featured > 0) {
    NSURLQueryItem *featuredQI = [NSURLQueryItem
        queryItemWithName:@"featured"
                    value:[NSString
                              stringWithFormat:@"%lu",
                                               (unsigned long)self.featured]];
    [queryItems addObject:featuredQI];
  }

  if (self.hasGeotag) {
    NSString *val = (_hasGeotag.boolValue) ? @"true" : @"false";
    NSURLQueryItem *hasGeoTagQI =
        [NSURLQueryItem queryItemWithName:@"has_geotag" value:val];
    [queryItems addObject:hasGeoTagQI];
  }

  if (self.hasLink) {
    NSString *val = (_hasLink.boolValue) ? @"true" : @"false";
    NSURLQueryItem *hasLinkQI =
        [NSURLQueryItem queryItemWithName:@"has_link" value:val];
    [queryItems addObject:hasLinkQI];
  }

  if (self.hasPhoto) {
    NSString *val = (_hasPhoto.boolValue) ? @"true" : @"false";
    NSURLQueryItem *hasPhotoQI =
        [NSURLQueryItem queryItemWithName:@"has_photo" value:val];
    [queryItems addObject:hasPhotoQI];
  }

  if (self.hasVideo) {
    NSString *val = (_hasVideo.boolValue) ? @"true" : @"false";
    NSURLQueryItem *hasVideoQI =
        [NSURLQueryItem queryItemWithName:@"has_video" value:val];
    [queryItems addObject:hasVideoQI];
  }

  if (_hasPhotoOrVideo) {
    NSString *val = (_hasPhotoOrVideo.boolValue) ? @"true" : @"false";
    NSURLQueryItem *hasPhotoOrVideoQI =
        [NSURLQueryItem queryItemWithName:@"has_photo_or_video" value:val];
    [queryItems addObject:hasPhotoOrVideoQI];
  }

  if (self.withProductData) {
    NSString *val = (_withProductData.boolValue) ? @"true" : @"false";
    NSURLQueryItem *withProductDataQI =
        [NSURLQueryItem queryItemWithName:@"withProductData" value:val];
    [queryItems addObject:withProductDataQI];
  }

  if (self.includeComments) {
    NSString *val = (_includeComments.boolValue) ? @"true" : @"false";
    NSURLQueryItem *includeCommentsQI =
        [NSURLQueryItem queryItemWithName:@"include_comments" value:val];
    [queryItems addObject:includeCommentsQI];
  }

  if (self.externalId) {
    NSURLQueryItem *externalIdQI =
        [NSURLQueryItem queryItemWithName:@"externalId" value:self.externalId];
    [queryItems addObject:externalIdQI];
  }

  if (self.media) {

    NSError *error;
    NSData *jsonMediaData = [NSJSONSerialization dataWithJSONObject:self.media
                                                            options:0
                                                              error:&error];

    if (!jsonMediaData || error != nil) {
      [[BVLogger sharedLogger] error:@"Unable to parameterize media dictionary "
                                     @"for curations request."];
    } else {
      NSString *jsonString =
          [[NSString alloc] initWithData:jsonMediaData
                                encoding:NSUTF8StringEncoding];
      NSURLQueryItem *mediaQueryQI =
          [NSURLQueryItem queryItemWithName:@"media" value:jsonString];
      [queryItems addObject:mediaQueryQI];
    }
  }

  return queryItems;
}

@end
