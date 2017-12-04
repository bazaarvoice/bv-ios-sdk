//
//  BadgeTypeUtil.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBadgeType.h"

@implementation BVBadgeTypeUtil

+ (BVBadgeType)fromString:(nullable NSString *)str {

  if ([str isEqualToString:@"Merit"]) {
    return BVBadgeTypeMerit;
  }
  if ([str isEqualToString:@"Affiliation"]) {
    return BVBadgeTypeAffiliation;
  }
  if ([str isEqualToString:@"Rank"]) {
    return BVBadgeTypeRank;
  }
  return BVBadgeTypeCustom;
}

@end
