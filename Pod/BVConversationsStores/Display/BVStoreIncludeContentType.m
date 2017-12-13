//
//  BVStoreIncludeContentType.m
//  Conversations
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVStoreIncludeContentType.h"

@implementation BVStoreIncludeContentTypeUtil

+ (NSString *)toString:(BVStoreIncludeContentType)type {
  switch (type) {
  case BVStoreIncludeContentTypeReviews:
    return @"Reviews";
  }
}

@end
