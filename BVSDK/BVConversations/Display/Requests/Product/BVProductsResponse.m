//
//  ProductsResponse.m
//  BVSDK
//
//  Copyright © 2016 Bazaarvoice. All rights reserved.
//

#import "BVProductsResponse.h"
#import "BVConversationsInclude.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVNullHelper.h"
#import "BVProduct.h"

@implementation BVProductsResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVProduct alloc] initWithApiResponse:raw includes:includes];
}

@end
