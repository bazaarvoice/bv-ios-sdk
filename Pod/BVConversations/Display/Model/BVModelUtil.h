//
//  BVModelUtil.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBadge.h"
#import "BVContextDataValue.h"
#import "BVDimensionAndDistributionUtil.h"
#import "BVPhoto.h"
#import "BVSecondaryRating.h"
#import "BVVideo.h"
#import <Foundation/Foundation.h>

/// Internal class - used only within BVSDK
@interface BVModelUtil : NSObject

+ (nullable NSDate *)convertTimestampToDatetime:(nullable id)timestamp;
+ (nonnull NSArray<BVPhoto *> *)parsePhotos:(nullable id)apiResponse;
+ (nonnull NSArray<BVVideo *> *)parseVideos:(nullable id)apiResponse;
+ (nonnull NSArray<BVContextDataValue *> *)parseContextDataValues:
    (nullable id)apiResponse;
+ (nonnull NSArray<BVBadge *> *)parseBadges:(nullable id)apiResponse;
+ (nonnull NSArray<BVSecondaryRating *> *)parseSecondaryRatings:
    (nullable id)apiResponse;
+ (nullable TagDimensions)parseTagDimension:(nullable id)apiResponse;

@end
