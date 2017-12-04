//
//  BadgeType.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Type of badge. See BVBadge.h for usage.
 */
typedef NS_ENUM(NSInteger, BVBadgeType) {
  BVBadgeTypeMerit,
  BVBadgeTypeAffiliation,
  BVBadgeTypeRank,
  BVBadgeTypeCustom
};

@interface BVBadgeTypeUtil : NSObject

+ (BVBadgeType)fromString:(nullable NSString *)str;

@end
