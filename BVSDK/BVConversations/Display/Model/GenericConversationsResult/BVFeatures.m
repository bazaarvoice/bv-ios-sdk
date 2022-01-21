//
//  BVFeatures.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
// 


#import "BVFeatures.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVModelUtil.h"

@implementation BVFeatures

- (id)initWithApiResponse:(NSDictionary *)apiResponse
                 includes:(BVConversationsInclude *)includes {
  if ((self = [super init])) {


    SET_IF_NOT_NULL(self.productId, apiResponse[@"productId"])
    SET_IF_NOT_NULL(self.language, apiResponse[@"language"])

    self.features = [BVModelUtil parseFeatures:apiResponse[@"features"]];
      
  }
  return self;
}

@end
