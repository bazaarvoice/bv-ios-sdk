//
//  BVBulkRatingIncludeTypeValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVBULKRATINGINCLUDETYPEVALUE_H
#define BVBULKRATINGINCLUDETYPEVALUE_H

typedef NS_ENUM(NSInteger, BVBulkRatingIncludeTypeValue) {
  BVBulkRatingIncludeTypeValueBulkRatingReviews,
  BVBulkRatingIncludeTypeValueBulkRatingNativeReviews,
  BVBulkRatingIncludeTypeValueBulkRatingQuestions,
  BVBulkRatingIncludeTypeValueBulkRatingNativeAnswers,
  BVBulkRatingIncludeTypeValueBulkRatingAll
};

#endif /* BVBULKRATINGINCLUDETYPEVALUE_H */
