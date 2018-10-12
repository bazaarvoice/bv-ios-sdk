//
//  BVProductReview.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//

#import "BVCommon.h"
#import "BVProductReview+Private.h"

@implementation BVProductReview

- (id)initWithDict:(NSDictionary *)dict {
  if ((self = [super init])) {
    if (dict && ![dict isKindOfClass:[NSNull class]]) {
      SET_IF_NOT_NULL(self.reviewText, [dict objectForKey:@"text"]);
      SET_IF_NOT_NULL(self.reviewTitle, [dict objectForKey:@"title"]);
      SET_IF_NOT_NULL(self.reviewAuthorName, [dict objectForKey:@"authorName"]);
    }
  }
  return self;
}

@end
