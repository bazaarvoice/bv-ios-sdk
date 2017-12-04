//
//  BVBulkRatingsFilterType.h
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Filter a `BVBulkRatingsRequest` based on content locale.
 */
typedef NS_ENUM(NSInteger, BVBulkRatingsFilterType) {
  BVBulkRatingsFilterTypeContentLocale
};

@interface BVBulkRatingsFilterTypeUtil : NSObject

+ (nonnull NSString *)toString:(BVBulkRatingsFilterType)filterOperator;

@end
