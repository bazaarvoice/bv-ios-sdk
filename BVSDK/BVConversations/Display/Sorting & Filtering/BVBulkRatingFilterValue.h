//
//  BVBulkRatingFilterValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVBULKRATINGFILTERVALUE_H
#define BVBULKRATINGFILTERVALUE_H

/*
 Filter a `BVBulkRatingsRequest`.
 */
typedef NS_ENUM(NSInteger, BVBulkRatingFilterValue) {
  BVBulkRatingFilterValueBulkRatingProductId,
  BVBulkRatingFilterValueBulkRatingContentLocale
};

#endif /* BVBULKRATINGFILTERVALUE_H */
