//
//  ModelUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BVPhoto.h"
#import "BVVideo.h"
#import "BVContextDataValue.h"
#import "BVBadge.h"
#import "BVSecondaryRating.h"
#import "BVDimensionAndDistributionUtil.h"

/// Internal class - used only within BVSDK
@interface BVModelUtil : NSObject

+ (NSDate * _Nullable)convertTimestampToDatetime:(id _Nullable)timestamp;
+ (NSArray<BVPhoto *> * _Nonnull)parsePhotos:(id _Nullable)apiResponse;
+ (NSArray<BVVideo *> * _Nonnull)parseVideos:(id _Nullable)apiResponse;
+ (NSArray<BVContextDataValue *> * _Nonnull)parseContextDataValues:(id _Nullable)apiResponse;
+ (NSArray<BVBadge *> * _Nonnull)parseBadges:(id _Nullable)apiResponse;
+ (NSArray<BVSecondaryRating *> * _Nonnull)parseSecondaryRatings:(id _Nullable)apiResponse;
+ (TagDimensions _Nullable)parseTagDimension:(id _Nullable)apiResponse;

@end



