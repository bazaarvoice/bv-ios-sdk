//
//  BVCommentIncludeTypeValue.h
//  BVSDK
//
//  Copyright © 2018 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BVCOMMENTINCLUDETYPEVALUE_H
#define BVCOMMENTINCLUDETYPEVALUE_H

/// Types of Bazaarvoice content that can be included with a Profile.
typedef NS_ENUM(NSInteger, BVCommentIncludeTypeValue) {
  BVCommentIncludeTypeValueCommentAuthors,
  BVCommentIncludeTypeValueCommentProducts,
  BVCommentIncludeTypeValueCommentReviews
};

#endif /* BVCOMMENTINCLUDETYPEVALUE_H */
