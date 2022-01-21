//
//  BVFeaturesResponse.m
//  BVSDK
//
//  Copyright © 2022 Bazaarvoice. All rights reserved.
//

#import "BVFeaturesResponse.h"
#import "BVConversationsInclude.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVFeaturesResponse
- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVFeatures alloc] initWithApiResponse:raw includes:includes];
}
@end
