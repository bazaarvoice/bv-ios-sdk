//
//  RatingDistribution.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVRatingDistribution.h"

@implementation BVRatingDistribution

- (nullable id)initWithApiResponse:(nullable id)apiResponse {
  if ((self = [super init])) {
    if (!apiResponse || ![apiResponse isKindOfClass:[NSArray class]]) {
      return nil;
    }
    
    NSArray<NSDictionary *> *apiObject = (NSArray<NSDictionary *> *)apiResponse;
    self.rawDistribution = apiObject;
    for (NSDictionary *value in apiObject) {
      NSNumber *count = value[@"Count"];
      NSNumber *valueNum = value[@"RatingValue"];
        
      NSUInteger valueInt = [valueNum unsignedIntegerValue];
      switch (valueInt) {
      case 1:
        self.oneStarCount = count;
        break;
      case 2:
        self.twoStarCount = count;
        break;
      case 3:
        self.threeStarCount = count;
        break;
      case 4:
        self.fourStarCount = count;
        break;
      case 5:
        self.fiveStarCount = count;
        break;
      default:
        break;
      }
    }
  }
  return self;
}

@end
