//
//  BVCommentIncludeType.h
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Types of Bazaarvoice content that can be included with a Profile.
typedef NS_ENUM(NSInteger, BVCommentIncludeType) {
  BVCommentIncludeTypeReviews,
  BVCommentIncludeTypeProducts,
  BVCommentIncludeTypeAuthors
};

@interface BVCommentIncludeTypeUtil : NSObject

+ (NSString *)toString:(BVCommentIncludeType)type;

@end
