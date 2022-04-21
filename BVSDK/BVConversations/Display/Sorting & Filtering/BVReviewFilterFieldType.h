//
//  BVReviewFilterFieldType.h
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef BVReviewFilterFieldType_h
#define BVReviewFilterFieldType_h

typedef NS_ENUM(NSInteger, BVReviewFilterFieldType) {
  BVReviewFilterFieldTypeAdditionalField,
  BVReviewFilterFieldTypeContextDataValue,
  BVReviewFilterFieldTypeSecondaryRating,
  BVReviewFilterFieldTypeTag
};

#endif /* BVReviewFilterFieldType_h */
