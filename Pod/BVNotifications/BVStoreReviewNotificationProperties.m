//
//  BVStoreReviewNotificationProperties.m
//  Bazaarvoice SDK
//
//  Copyright 2016 Bazaarvoice Inc. All rights reserved.
//
//

#import "BVStoreReviewNotificationProperties.h"
#import "BVNullHelper.h"

@implementation BVStoreReviewNotificationProperties

- (id)init {

  self = [super init];

  // TODO: Suitable defaults if not remote config?

  return self;
}

- (id)initWithDictionary:(NSDictionary *)configDict {

  self = [super initWithDictionary:configDict];

  SET_IF_NOT_NULL(_defaultStoreImageUrl,
                  [configDict objectForKey:@"defaultStoreImageUrl"]);

  return self;
}

@end
