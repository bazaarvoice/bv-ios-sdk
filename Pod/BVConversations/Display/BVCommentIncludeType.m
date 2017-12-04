

//
//  BVCommentIncludeType.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentIncludeType.h"

@implementation BVCommentIncludeTypeUtil

+ (NSString *)toString:(BVCommentIncludeType)type {
  switch (type) {
  case BVCommentIncludeTypeProducts:
    return @"Products";
  case BVCommentIncludeTypeReviews:
    return @"Reviews";
  case BVCommentIncludeTypeAuthors:
    return @"Authors";
  }
}

@end
