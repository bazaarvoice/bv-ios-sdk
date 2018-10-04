//
//  Badge.m
//  Pods
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVBadge.h"
#import "BVNullHelper.h"

@implementation BVBadge

- (id)initWithApiResponse:(nonnull NSDictionary *)apiResponse {
  if ((self = [super init])) {
    self.badgeType =
        [BVBadgeTypeUtil fromString:[apiResponse objectForKey:@"BadgeType"]];
    SET_IF_NOT_NULL(self.identifier, apiResponse[@"Id"])
    SET_IF_NOT_NULL(self.contentType, apiResponse[@"ContentType"])
  }
  return self;
}

@end
