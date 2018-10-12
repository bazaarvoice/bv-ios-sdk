//
//  BVAuthorResponse.m
//  BVSDK
//
//  Copyright © 2017 Bazaarvoice. All rights reserved.
//

#import "BVAuthorResponse.h"
#import "BVConversationsInclude.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"

@implementation BVAuthorResponse
- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVAuthor alloc] initWithApiResponse:raw includes:includes];
}
@end
