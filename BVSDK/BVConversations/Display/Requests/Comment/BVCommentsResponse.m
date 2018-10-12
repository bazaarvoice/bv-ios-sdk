//
//  BVCommentsRespose.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsResponse.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"

@implementation BVCommentsResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVComment alloc] initWithApiResponse:raw includes:includes];
}

@end
