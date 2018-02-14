//
//  BVAuthorIncludeTypeValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVAUTHORINCLUDETYPEVALUE_H
#define BVAUTHORINCLUDETYPEVALUE_H

/// Types of Bazaarvoice content that can be included with a Profile.
typedef NS_ENUM(NSInteger, BVAuthorIncludeTypeValue) {
  BVAuthorIncludeTypeValueAuthorReviews,
  BVAuthorIncludeTypeValueAuthorQuestions,
  BVAuthorIncludeTypeValueAuthorAnswers,
  BVAuthorIncludeTypeValueAuthorReviewComments
};

#endif /* BVAUTHORINCLUDETYPEVALUE_H */
