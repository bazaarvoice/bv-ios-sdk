//
//  BVModelUtil.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVModelUtil.h"

@implementation BVModelUtil

+ (nullable NSDate *)convertTimestampToDatetime:(nullable id)timestamp {
  NSDate *dateTime;
  if (!timestamp || ![timestamp isKindOfClass:[NSString class]]) {
    return nil;
  }
  NSString *timestampString = timestamp;

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSX"]; // UTC format
  dateTime = [dateFormatter dateFromString:timestampString];
    
  if (dateTime == nil) {
    [dateFormatter setDateFormat:@"yyyy-MM-dd'@'HH:mm:ss"];
    dateTime = [dateFormatter dateFromString:timestampString];
    }
  return dateTime;
}

+ (nonnull NSArray<BVPhoto *> *)parsePhotos:(nullable id)apiResponse {
  NSMutableArray<BVPhoto *> *tempValues = [NSMutableArray array];

  for (NSDictionary *photo in apiResponse) {
    [tempValues addObject:[[BVPhoto alloc] initWithApiResponse:photo]];
  }
  return tempValues;
}

+ (nonnull NSArray<BVVideo *> *)parseVideos:(nullable id)apiResponse {
  NSMutableArray<BVVideo *> *tempValues = [NSMutableArray array];

  for (NSDictionary *photo in apiResponse) {
    [tempValues addObject:[[BVVideo alloc] initWithApiResponse:photo]];
  }
  return tempValues;
}
+ (nonnull NSArray<BVContextDataValue *> *)parseContextDataValues:
    (nullable id)apiResponse {
  NSMutableArray<BVContextDataValue *> *tempValues = [NSMutableArray array];
  NSDictionary *apiObject = apiResponse;
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    [tempValues
        addObject:[[BVContextDataValue alloc] initWithApiResponse:value]];
  }
  return tempValues;
}

+ (nonnull NSArray<BVBadge *> *)parseBadges:(nullable id)apiResponse {
  NSMutableArray<BVBadge *> *tempValues = [NSMutableArray array];
  NSDictionary *apiObject = apiResponse;
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    [tempValues addObject:[[BVBadge alloc] initWithApiResponse:value]];
  }
  return tempValues;
}
+ (nonnull NSArray<BVSecondaryRating *> *)parseSecondaryRatings:
    (nullable id)apiResponse {
  NSMutableArray<BVSecondaryRating *> *tempValues = [NSMutableArray array];
  NSDictionary *apiObject = apiResponse;
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    [tempValues
        addObject:[[BVSecondaryRating alloc] initWithApiResponse:value]];
  }
  return tempValues;
}
+ (nullable TagDimensions)parseTagDimension:(nullable id)apiResponse {
  TagDimensions tempResult = [NSMutableDictionary dictionary];
  NSDictionary *apiObject = apiResponse;
  for (NSString *key in apiObject) {
    NSDictionary *value = [apiObject objectForKey:key];
    [tempResult setObject:[[BVDimensionElement alloc] initWithApiResponse:value]
                   forKey:key];
  }
  return tempResult;
}

@end
