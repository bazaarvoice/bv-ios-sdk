//
//  BVProductSearchResponse.m
//  Bazaarvoice SDK
//
//  Copyright 2017 Bazaarvoice Inc. All rights reserved.
//

#import "BVBulkProductResponse.h"
#import "BVDisplayResponse+Private.h"
#import "BVGenericConversationsResult+Private.h"
#import "BVProduct.h"

@implementation BVBulkProductResponse

- (id)createResult:(NSDictionary *)raw
          includes:(BVConversationsInclude *)includes {
  return [[BVProduct alloc] initWithApiResponse:raw includes:includes];
}

@end
