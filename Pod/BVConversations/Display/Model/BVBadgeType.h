//
//  BadgeType.h
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Type of badge. See BVBage.h for usage.
 */
typedef NS_ENUM(NSInteger, BVBadgeType) {
    BVBadgeTypeMerit,
    BVBadgeTypeAffiliation,
    BVBadgeTypeRank,
    BVBadgeTypeCustom
};

@interface BVBadgeTypeUtil : NSObject

+ (BVBadgeType)fromString:(NSString* _Nullable)str;

@end

