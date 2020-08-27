//
//  BVReviewIncludeTypeValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVREVIEWINCLUDETYPEVALUE_H
#define BVREVIEWINCLUDETYPEVALUE_H

/// Types of Bazaarvoice content that can be included with a Profile.
typedef NS_ENUM(NSInteger, BVReviewIncludeTypeValue) {
  BVReviewIncludeTypeValueReviewProducts,
  BVReviewIncludeTypeValueReviewAuthors,
  BVReviewIncludeTypeValueReviewComments
};

#endif /* BVREVIEWINCLUDETYPEVALUE_H */
