//
//  BVCommentsRespose.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVCommentsResponse.h"

@implementation BVCommentsResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVComment alloc] initWithApiResponse:raw includes:includes];
}

@end
